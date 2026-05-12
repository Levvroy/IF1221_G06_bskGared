:- dynamic giliran/1.
:- dynamic kartudiTangan/2.
:- dynamic kartuTeratas/2.
:- dynamic warnaActive/1.
:- dynamic sisaDeck/1.
:- dynamic sudahMainKartu/1.
:- dynamic statusUni/1.
:- dynamic penantangWDF/1.

:- include('kartu.pl').

startGame :-
    write('Masukkan jumlah pemain: '),
    read(N),
    (integer(N), N >= 2, N =< 4 -> 
        nl, inputNamaPemain(N, [], DaftarNama),
        inisialisasiGame(DaftarNama) 
    ; 
        write('Mohon masukkan angka antara 2 - 4.'), nl, 
        startGame
    ).

inisialisasiGame(DaftarNama) :-
    hapusDataLama,
    acakList(DaftarNama, UrutanBaru),
    buatDeckBaru(DeckLengkap),
    bagiKartuPemain(UrutanBaru, DeckLengkap, DeckSisa),
    setKartuAwal(DeckSisa, kartu(WarnaAwal, AngkaAwal), DeckFinal),
    
    assertz(giliran(UrutanBaru)),
    assertz(kartuTeratas(WarnaAwal, AngkaAwal)),
    assertz(warnaActive(WarnaAwal)),
    assertz(sisaDeck(DeckFinal)),
    assertz(sudahMainKartu(false)),
    assertz(statusUni([])),
    assertz(penantangWDF(none)),
    
    nl,
    write('Urutan pemain: '),
    tampilkanUrutan(UrutanBaru),
    write('.'), nl, nl,
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl, nl,
    write('Kartu discard top: '),
    write(WarnaAwal), write('-'), write(AngkaAwal),
    nl, nl,
    UrutanBaru = [Pertama|_],
    write('Giliran '), write(Pertama), write('.'), nl,
    !.

hapusDataLama :-
    retractall(giliran(_)),
    retractall(kartudiTangan(_, _)),
    retractall(kartuTeratas(_, _)),
    retractall(warnaActive(_)),
    retractall(sisaDeck(_)),
    retractall(sudahMainKartu(_)),
    retractall(statusUni(_)),
    retractall(penantangWDF(_)).

inputNamaPemain(N, Acc, Result) :-
    bacaNamaPemain(1, N, Acc, Result).

bacaNamaPemain(Index, Total, Acc, Result) :-
    Index > Total, !, reverseList(Acc, Result).

bacaNamaPemain(Index, Total, Acc, Result) :-
    write('Masukkan nama pemain '), write(Index), write(': '), read(Nama),
    cekNamaUnik(Nama, Acc, NamaValid),
    NextIndex is Index + 1,
    bacaNamaPemain(NextIndex, Total, [NamaValid|Acc], Result).

cekNamaUnik(Nama, Acc, Nama) :-
    \+ cekMember(Nama, Acc), !.

cekNamaUnik(_, Acc, NamaValid) :-
    write('Nama sudah digunakan. Masukkan nama lain: '), read(NamaBaru),
    cekNamaUnik(NamaBaru, Acc, NamaValid).

tampilkanUrutan([P]) :- write(P), !.
tampilkanUrutan([P|T]) :- write(P), write(' - '), tampilkanUrutan(T).

bagiKartuPemain([], Deck, Deck).
bagiKartuPemain([Pemain|SisaPemain], DeckAwal, SisaDeckAkhir) :-
    ambilNKartu(7, DeckAwal, TanganPemain, DeckSisa),
    assertz(kartudiTangan(Pemain, TanganPemain)),
    bagiKartuPemain(SisaPemain, DeckSisa, SisaDeckAkhir).

ambilNKartu(0, Deck, [], Deck) :- !.
ambilNKartu(N, [Kartu|SisaDeck], [Kartu|SisaTangan], SisaAkhir) :-
    N > 0, N1 is N - 1,
    ambilNKartu(N1, SisaDeck, SisaTangan, SisaAkhir).

setKartuAwal([kartu(Warna, Jenis)|SisaDeck], kartu(Warna, Jenis), SisaDeck) :-
    integer(Jenis), !.

setKartuAwal([Kartu|SisaDeck], KartuAtas, FinalDeck) :-
    taruhBelakang(SisaDeck, Kartu, DeckBaru),
    setKartuAwal(DeckBaru, KartuAtas, FinalDeck).

buatDeckBaru(DeckAcak) :-
    findall(kartu(Warna, Jenis), kartu(Warna, Jenis), SemuaKartu),
    acakList(SemuaKartu, DeckAcak).

cekMember(X, [X|_]) :- !.
cekMember(X, [_|T]) :- cekMember(X, T).

reverseList([], []).
reverseList([H|T], Reversed) :-
    reverseList(T, RevT),
    taruhBelakang(RevT, H, Reversed).

taruhBelakang([], Elemen, [Elemen]).
taruhBelakang([H|T], Elemen, [H|TBaru]) :-
    taruhBelakang(T, Elemen, TBaru).

acakList([], []).
acakList(List, [Elemen|SisaAcak]) :-
    hitungPanjang(List, Panjang),
    IndexRandom is random(Panjang),
    ambilDanHapus(IndexRandom, List, Elemen, SisaList),
    acakList(SisaList, SisaAcak).

hitungPanjang([], 0).
hitungPanjang([_|T], N) :-
    hitungPanjang(T, N1),
    N is N1 + 1.

ambilDanHapus(0, [H|T], H, T) :- !.
ambilDanHapus(N, [H|T], Elemen, [H|SisaT]) :-
    N > 0, N1 is N - 1,
    ambilDanHapus(N1, T, Elemen, SisaT).