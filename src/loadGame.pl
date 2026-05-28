% loadGame

:- dynamic(giliran/1).
:- dynamic(kartudiTangan/2).
:- dynamic(kartuTeratas/2).
:- dynamic(warnaActive/1).
:- dynamic(statusUni/1).
:- dynamic(arahPermainan/1).
:- dynamic(penantangWDF/1).
:- dynamic(sudahMainKartu/1).
:- dynamic(tumpukan_kartu/1).
:- dynamic(kartuTersembunyi/2).
:- dynamic(giliranAktifTemp/1).

reverse_list(List, Reversed) :- reverse_helper(List, [], Reversed).
reverse_helper([], Acc, Acc).
reverse_helper([Head|Tail], Acc, Reversed) :- reverse_helper(Tail, [Head|Acc], Reversed).

append_element([], Element, [Element]).
append_element([Head|Tail], Element, [Head|NewTail]) :- append_element(Tail, Element, NewTail).

gabungList([], L, L).
gabungList([H|T], L2, [H|Hasil]) :- gabungList(T, L2, Hasil).

rotasiKeDepan([X|T], X, [X|T]) :- !.
rotasiKeDepan([H|T], X, Hasil) :- append_element(T, H, Rotasi), rotasiKeDepan(Rotasi, X, Hasil).

adaDiList(X, [X|_]) :- !.
adaDiList(X, [_|T]) :- adaDiList(X, T).

hapusSatu(_, [], []).
hapusSatu(K, [K|T], T) :- !.
hapusSatu(K, [H|T], [H|Hasil]) :- hapusSatu(K, T, Hasil).

semuaWarna([merah, kuning, hijau, biru]).
semuaJenis([0,1,2,3,4,5,6,7,8,9,skip,reverse,drawTwo]).

buatDeckLengkap(Deck) :-
    semuaWarna(Warna), semuaJenis(Jenis),
    buatKartuBerwarna(Warna, Jenis, KartuBerwarna),
    KartuHitam = [
        kartu(hitam, wild), kartu(hitam, wild),
        kartu(hitam, wild), kartu(hitam, wild),
        kartu(hitam, wildDrawFour), kartu(hitam, wildDrawFour),
        kartu(hitam, wildDrawFour), kartu(hitam, wildDrawFour)
    ],
    gabungList(KartuBerwarna, KartuHitam, Deck).

buatKartuBerwarna([], _, []).
buatKartuBerwarna([W|RestW], Jenis, Hasil) :-
    buatSatuWarna(W, Jenis, KartuW),
    buatKartuBerwarna(RestW, Jenis, RestHasil),
    gabungList(KartuW, RestHasil, Hasil).

buatSatuWarna(W, [], []).
buatSatuWarna(W, [J|RestJ], Hasil) :-
    buatSatuWarna(W, RestJ, RestHasil),
    (integer(J), J =:= 0 -> gabungList([kartu(W,J)], RestHasil, Hasil)
    ; gabungList([kartu(W,J), kartu(W,J)], RestHasil, Hasil)).

kumpulkanTerpakai(ListPemain, Terpakai) :-
    kumpulkanTangan(ListPemain, KartuTangan),
    kartuTeratas(W, J),
    gabungList([kartu(W,J)], KartuTangan, Terpakai).

kumpulkanTangan([], []).
kumpulkanTangan([P|Rest], Hasil) :-
    (kartudiTangan(P, Tangan) -> true ; Tangan = []),
    kumpulkanTangan(Rest, RestHasil),
    gabungList(Tangan, RestHasil, Hasil).

buatSisaDeck([], _, []).
buatSisaDeck([K|Rest], Terpakai, Hasil) :-
    adaDiList(K, Terpakai), !,
    hapusSatu(K, Terpakai, TerpakaiBaru),
    buatSisaDeck(Rest, TerpakaiBaru, Hasil).
buatSisaDeck([K|Rest], Terpakai, [K|Hasil]) :-
    buatSisaDeck(Rest, Terpakai, Hasil).

% Baca File .txt
baca_baris_loop(Stream) :-
    at_end_of_stream(Stream), !.
baca_baris_loop(Stream) :-
    baca_satu_baris(Stream, [], KarakterList),
    (KarakterList \= [] -> parse_baris_ascii(KarakterList) ; true),
    baca_baris_loop(Stream).

baca_satu_baris(Stream, Acc, Hasil) :-
    get_code(Stream, Code),
    (Code = -1 -> Hasil = Acc
    ; Code = 10 -> Hasil = Acc
    ; Code = 13 -> baca_satu_baris(Stream, Acc, Hasil)
    ; append_element(Acc, Code, NewAcc), baca_satu_baris(Stream, NewAcc, Hasil)).

parse_baris_ascii(KarakterList) :-
    split_key_value(KarakterList, KeyCodes, ValueCodes),
    atom_codes(Key, KeyCodes),
    atom_codes(ValueAtom, ValueCodes),
    restore_fakta_ascii(Key, ValueAtom), !.

split_key_value([58|Tail], [], Tail) :- !.
split_key_value([Head|Tail], [Head|KeyTail], Value) :- split_key_value(Tail, KeyTail, Value).

restore_fakta_ascii(arah_permainan, Value) :- !, retractall(arahPermainan(_)), assertz(arahPermainan(Value)).
restore_fakta_ascii(warna_aktif, Value) :- !, retractall(warnaActive(_)), assertz(warnaActive(Value)).
restore_fakta_ascii(discard_top, Value) :- !,
    split_strip(Value, W, J), retractall(kartuTeratas(_,_)), assertz(kartuTeratas(W, J)).
restore_fakta_ascii(urutan_pemain, Value) :- !,
    parse_list_pemain(Value, List), retractall(giliran(_)), assertz(giliran(List)).
restore_fakta_ascii(giliran, Value) :- !,
    retractall(giliranAktifTemp(_)), assertz(giliranAktifTemp(Value)).
restore_fakta_ascii(status_uni, Value) :- !,
    parse_list_pemain(Value, List), retractall(statusUni(_)), assertz(statusUni(List)).
restore_fakta_ascii(kartu_tersembunyi, Value) :- !,
    atom_string(Value, Str), split_string(Str, "-", "", [PStr, WStr, JStr]),
    atom_string(P, PStr), atom_string(W, WStr), atom_string(J, JStr),
    (atom_number(J, Angka) -> JVal = Angka ; JVal = J),
    retractall(kartuTersembunyi(P, _)), assertz(kartuTersembunyi(P, kartu(W, JVal))).
restore_fakta_ascii(Key, Value) :-
    atom_string(Key, KeyStr), string_concat("kartu_", NamaPemainStr, KeyStr), !,
    atom_string(NamaPemain, NamaPemainStr),
    parse_list_kartu(Value, ListKartu),
    retractall(kartudiTangan(NamaPemain, _)), assertz(kartudiTangan(NamaPemain, ListKartu)).
restore_fakta_ascii(_, _).

split_strip(AtomInput, W, J) :-
    atom_string(AtomInput, Str), split_string(Str, "-", "", [WStr, JStr]),
    atom_string(W, WStr), atom_string(J, JStr),
    (atom_number(J, Angka) -> J = Angka ; true).

parse_list_pemain(AtomList, Hasil) :-
    atom_string(AtomList, Str), string_concat("[", Tmp1, Str), string_concat(Tmp2, "]", Tmp1),
    (Tmp2 = "" -> Hasil = []
    ; split_string(Tmp2, ",", "", StrList), map_string_to_atom(StrList, Hasil)).

map_string_to_atom([], []).
map_string_to_atom([H|T], [AtomH|AtomT]) :- atom_string(AtomH, H), map_string_to_atom(T, AtomT).

parse_list_kartu(AtomList, Hasil) :-
    atom_string(AtomList, Str), string_concat("[", Tmp1, Str), string_concat(Tmp2, "]", Tmp1),
    (Tmp2 = "" -> Hasil = []
    ; split_string(Tmp2, ",", "", StrList), build_kartu_list(StrList, Hasil)).

build_kartu_list([], []).
build_kartu_list([H|T], [kartu(W, JVal)|Tail]) :-
    split_string(H, "-", "", [WStr, JStr]),
    atom_string(W, WStr), atom_string(J, JStr),
    (atom_number(J, Angka) -> JVal = Angka ; JVal = J),
    build_kartu_list(T, Tail).

restoreStateTetap :-
    retractall(penantangWDF(_)), assertz(penantangWDF(none)),
    retractall(sudahMainKartu(_)), assertz(sudahMainKartu(false)).

restoreGiliran :-
    (giliranAktifTemp(GiliranAktif) ->
        giliran(UrutanPemain),
        rotasiKeDepan(UrutanPemain, GiliranAktif, UrutanRotasi),
        retractall(giliran(_)), assertz(giliran(UrutanRotasi)),
        retractall(giliranAktifTemp(_))
    ; true).

restoreTumpukan :-
    giliran(ListPemain),
    buatDeckLengkap(DeckLengkap),
    kumpulkanTerpakai(ListPemain, Terpakai),
    buatSisaDeck(DeckLengkap, Terpakai, SisaDeck),
    retractall(tumpukan_kartu(_)),
    assertz(tumpukan_kartu(SisaDeck)).

loadGame :-
    write('Masukkan nama file yang akan dimuat: '),
    read(NamaFile),
    atom_string(NamaFile, NamaStr),
    string_concat(NamaStr, '.txt', NamaFileExt),
    atom_string(NamaFileAtom, NamaFileExt),
    (exists_file(NamaFileAtom) ->
        open(NamaFileAtom, read, Stream),
        baca_baris_loop(Stream),
        close(Stream),
        restoreGiliran,
        restoreStateTetap,
        restoreTumpukan,
        giliran([GiliranSekarang|_]),
        write('Status permainan berhasil dimuat dari '), write(NamaFileExt), write('.'), nl,
        write('Melanjutkan giliran '), write(GiliranSekarang), write('.'), nl
    ;
        write('Error: File '), write(NamaFileExt), write(' tidak ditemukan'), nl, fail
    ).