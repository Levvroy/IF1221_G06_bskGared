:- dynamic(giliran/1).
:- dynamic(kartudiTangan/2).
:- dynamic(kartuTeratas/2).
:- dynamic(warnaActive/1).
:- dynamic(statusUni/1).
:- dynamic(arahPermainan/1).
:- dynamic(kartuTersembunyi/2). % penambahan dari spesifikasi bonus

saveGame :-
    write('Masukkan nama file penyimpanan: '),
    read(NamaFile),
    atom_string(NamaFile, NamaStr),
    string_concat(NamaStr, '.txt', NamaFileExt),
    atom_string(NamaFileAtom, NamaFileExt),
    tell(NamaFileAtom),
    tulisSemuaData,
    told,
    write('Status permainan berhasil disimpan ke '), write(NamaFileExt), write('.'), nl.

tulisSemuaData :-
    tulisArahPermainan,
    tulisUrutanPemain,
    tulisGiliran,
    tulisDiscardTop,
    tulisWarnaAktif,
    tulisStatusUni,
    tulisKartuTersembunyi,
    tulisKartuSemuaPemain.

tulisArahPermainan :-
    arahPermainan(Arah),
    write('arah_permainan:'), write(Arah), nl.

tulisUrutanPemain :-
    giliran(ListPemain),
    write('urutan_pemain:'),
    tulisListPemain(ListPemain), nl.

tulisGiliran :-
    giliran([Sekarang|_]),
    write('giliran:'), write(Sekarang), nl.

tulisDiscardTop :-
    kartuTeratas(W, J),
    write('discard_top:'), write(W), write('-'), write(J), nl.

tulisWarnaAktif :-
    warnaActive(Warna),
    write('warna_aktif:'), write(Warna), nl.

tulisStatusUni :-
    statusUni(ListUni),
    write('status_uni:'),
    tulisListPemain(ListUni), nl.

tulisKartuTersembunyi :-
    \+ kartuTersembunyi(_, _), !.

tulisKartuTersembunyi :-
    giliran(ListPemain),
    tulisTersembunyiPerPemain(ListPemain).

tulisTersembunyiPerPemain([]).
tulisTersembunyiPerPemain([P|Sisa]) :-
    (kartuTersembunyi(P, kartu(W,J)) ->
        write('kartu_tersembunyi:'), write(P), write('-'), write(W), write('-'), write(J), nl
    ; true),
    tulisTersembunyiPerPemain(Sisa).

tulisKartuSemuaPemain :-
    giliran(ListPemain),
    tulisKartuPerPemain(ListPemain).

tulisKartuPerPemain([]).
tulisKartuPerPemain([P|Sisa]) :-
    kartudiTangan(P, Tangan),
    write('kartu_'), write(P), write(':'),
    tulisListKartu(Tangan), nl,
    tulisKartuPerPemain(Sisa).

tulisListPemain(List) :-
    write('['),
    tulisIsiListPemain(List),
    write(']').

tulisIsiListPemain([]).
tulisIsiListPemain([X]) :- write(X), !.
tulisIsiListPemain([X|T]) :-
    write(X), write(','),
    tulisIsiListPemain(T).

tulisListKartu(List) :-
    write('['),
    tulisIsiListKartu(List),
    write(']').

tulisIsiListKartu([]).
tulisIsiListKartu([kartu(W,J)]) :-
    write(W), write('-'), write(J), !.
tulisIsiListKartu([kartu(W,J)|T]) :-
    write(W), write('-'), write(J), write(','),
    tulisIsiListKartu(T).