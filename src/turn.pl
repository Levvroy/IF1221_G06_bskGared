:- dynamic giliran/1.
:- dynamic kartudiTangan/2.
:- dynamic kartuTeratas/2.
:- dynamic warnaAktive/1.
:- dynamic sudahMainKartu/1. 
:- dynamic statusUni/1. 
:- dynamic penantangWDF/1. 

nextTurn :-
    giliran([Sekarang | Sisa]),
    append(Sisa, [Sekarang], ListBaru),
    retract(giliran(_)),
    assertz(giliran(ListBaru)),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(false)),
    giliran([Berikutnya | _]),
    write('Giliran '), write(Berikutnya), write('.'), nl.

ambilIndex(1, [H|_], H) :- !.
ambilIndex(N, [_|T], X) :-
    N > 1,
    N1 is N - 1,
    ambilIndex(N1, T, X).

hapusIndex(1, [_|T], T) :- !.
hapusIndex(N, [H|T], [H|Hasil]) :-
    N > 1,
    N1 is N - 1,
    hapusIndex(N1, T, Hasil).

bisaDimainkan(hitam, _) :- !.

bisaDimainkan(Warna, _) :-
    warnaActive(Warna), !.

bisaDimainkan(_, Jenis) :-
    kartuTeratas(_, JenisTeratas),
    Jenis = JenisTeratas, !.

mainkanKartu(N) :-
    sudahMainKartu(false),
    giliran([Pemain | _]),
    kartudiTangan(Pemain, TanganPemain),
    length(TanganPemain, JumlahKartu),
    N >= 1, N =< JumlahKartu,
    ambilIndex(N, TanganPemain, kartu(Warna, Jenis)),
    bisaDimainkan(Warna, Jenis),
    !,
    (  Jenis = wildDrawFour
    -> (  valid_lempar_wild_draw_four(Pemain)
        -> true
        ;  write('[Peringatan] Kamu masih punya kartu yang bisa dimainkan. Tapi boleh aja sih, nanti bisa ditantang.'), nl
        )
    ;  true
    ),
    hapusIndex(N, TanganPemain, TanganBaru),
    retract(kartudiTangan(Pemain, _)),
    assertz(kartudiTangan(Pemain, TanganBaru)),
    retract(kartuTeratas(_, _)),
    assertz(kartuTeratas(Warna, Jenis)),
    write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    retract(statusUni(ListUni)),
    delete(ListUni, Pemain, ListUniBaru),
    assertz(statusUni(ListUniBaru)),
    efek_kartu(Jenis),
    (  TanganBaru = []
    -> endGame(Pemain)
    ;  nextTurn
    ).

mainkanKartu(_) :-
    sudahMainKartu(true),
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl, fail.

mainkanKartu(N) :-
    giliran([Pemain | _]),
    kartudiTangan(Pemain, Tangan),
    length(Tangan, Max),
    (  (N < 1 ; N > Max)
    -> write('Nomor kartu tidak valid.'), nl
    ;  ambilIndex(N, Tangan, kartu(Warna, Jenis)),
       write('Kartu '), write(Warna), write('-'), write(Jenis), write(' tidak bisa dimainkan sekarang.'), nl
    ), fail.

ambilKartu :-
    sudahMainKartu(false),
    !,
    giliran([Pemain | _]),
    findall(kartu(W,J), kartu(W,J), SemuaKartu),
    length(SemuaKartu, Total),
    random(0, Total, Idx),
    Idx1 is Idx + 1,
    ambilIndex(Idx1, SemuaKartu, KartuBaru),
    kartudiTangan(Pemain, Tangan),
    append(Tangan, [KartuBaru], TanganBaru),
    retract(kartudiTangan(Pemain, _)),
    assertz(kartudiTangan(Pemain, TanganBaru)),
    write(Pemain), write(' mengambil 1 kartu.'), nl,
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    nextTurn.

ambilKartu :-
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl, fail.

lihatCommand :-
    sudahMainKartu(Status),
    nl, write('Aksi utama yang tersedia:'), nl,
    (  Status = false
    -> write('1. mainkanKartu(N)'), nl,
        write('2. ambilKartu'), nl,
        write('3. tantang'), nl,
        write('4. uni(N)'), nl
    ;   write('(sudah digunakan pada giliran ini)'), nl
    ),
    nl, write('Aksi pendukung yang tersedia:'), nl,
    write('1. tangkap(NamaPemain)'), nl,
    write('2. lihatCommand'), nl,
    write('3. lihatKartu'), nl,
    write('4. cekInfo'), nl.

lihatKartu :-
    giliran([Pemain | _]),
    write('Berikut kartu yang anda miliki.'), nl,
    kartudiTangan(Pemain, Tangan),
    cetakKartu(Tangan, 1).

cetakKartu([], _).
cetakKartu([kartu(W,J)|T], N) :-
    write(N), write('. '), write(W), write('-'), write(J), nl,
    N1 is N + 1,
    cetakKartu(T, N1).

cekInfo :-
    kartuTeratas(W, J),
    write('Kartu discard top: '), write(W), write('-'), write(J), write('.'), nl, nl,
    giliran(ListPemain),
    write('Urutan pemain: '),
    cetakUrutan(ListPemain), nl, nl,
    cetakInfoPemain(ListPemain, 1).

cetakUrutan([X]) :- write(X), nl, !.
cetakUrutan([H|T]) :- write(H), write(' - '), cetakUrutan(T).

cetakInfoPemain([], _).
cetakInfoPemain([P|T], N) :-
    kartudiTangan(P, Tangan),
    length(Tangan, Jumlah),
    write('Nama pemain '), write(N), write(': '), write(P), nl,
    write('Jumlah kartu : '), write(Jumlah), nl, nl,
    N1 is N + 1,
    cetakInfoPemain(T, N1).