:- dynamic(giliran/1).
:- dynamic(kartudiTangan/2).
:- dynamic(kartuTeratas/2).
:- dynamic(warnaActive/1).
:- dynamic(statusUni/1).
:- dynamic(arahPermainan/1).
:- dynamic(kartuTersembunyi/2).
:- dynamic(aksiTerakhir/4).

saveGame :-
    write('Masukkan nama file penyimpanan: '),
    read(NamaFile),
    atom_concat(NamaFile, '.txt', NamaFileAtom),
    tell(NamaFileAtom),
    tulisSemuaData,
    told,
    write('Status permainan berhasil disimpan ke '), write(NamaFileAtom), write('.'), nl.

tulisSemuaData :-
    tulisUrutanPemain,
    tulisGiliran,
    tulisDiscardTop,
    tulisWarnaAktif,
    tulisArahPermainan,
    tulisStatusUni,
    tulisAksiTerakhir,
    tulisKartuTersembunyi,
    tulisKartuSemuaPemain.

tulisUrutanPemain :-
    giliran(ListPemain),
    write('urutan_pemain:'),
    tulisListPemain(ListPemain), nl.

tulisGiliran :-
    giliran([Sekarang|_]),
    write('giliran:'), writeq(Sekarang), nl.

tulisDiscardTop :-
    kartuTeratas(W, J),
    write('discard_top:'), write(W), write('-'), write(J), nl.

tulisWarnaAktif :-
    warnaActive(Warna),
    write('warna_aktif:'), write(Warna), nl.

tulisArahPermainan :-
    arahPermainan(Arah),
    write('arah_permainan:'), write(Arah), nl.

tulisStatusUni :-
    statusUni(ListUni),
    write('status_UNI:'),
    tulisListPemain(ListUni), nl.

tulisAksiTerakhir :-
    (aksiTerakhir(W, J, Pemain, _) ->
        write('kartu_aksi_terakhir:'),
        write(W), write('-'), write(J), write('-'), writeq(Pemain), nl
    ; true).

tulisKartuTersembunyi :-
    \+ kartuTersembunyi(_, _), !.
tulisKartuTersembunyi :-
    giliran(ListPemain),
    tulisTersembunyiPerPemain(ListPemain).

tulisTersembunyiPerPemain([]).
tulisTersembunyiPerPemain([P|Sisa]) :-
    (kartuTersembunyi(P, kartu(W,J)) ->
        write('kartu_tersembunyi:'), writeq(P), write('-'), write(W), write('-'), write(J), nl
    ; true),
    tulisTersembunyiPerPemain(Sisa).

tulisKartuSemuaPemain :-
    giliran(ListPemain),
    tulisKartuPerPemain(ListPemain).

tulisKartuPerPemain([]).
tulisKartuPerPemain([P|Sisa]) :-
    kartudiTangan(P, Tangan),
    write('kartu('), writeq(P), write('):'),
    tulisListKartu(Tangan), nl,
    tulisKartuPerPemain(Sisa).

tulisListPemain(List) :-
    write('['),
    tulisIsiListPemain(List),
    write(']').

tulisIsiListPemain([]).
tulisIsiListPemain([X]) :- writeq(X), !.
tulisIsiListPemain([X|T]) :-
    writeq(X), write(','),
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
