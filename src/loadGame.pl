:- dynamic(giliran/1).
:- dynamic(kartudiTangan/2).
:- dynamic(kartuTeratas/2).
:- dynamic(warnaActive/1).
:- dynamic(statusUni/1).
:- dynamic(arahPermainan/1).
:- dynamic(penantangWDF/1).
:- dynamic(sudahMainKartu/1).
:- dynamic(statusBluffWDF/1).
:- dynamic(tumpukan_kartu/1).
:- dynamic(kartuTersembunyi/2).
:- dynamic(aksiTerakhir/4).
:- dynamic(giliranKe/1).
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
        kartu(hitam, wild),         kartu(hitam, wild),
        kartu(hitam, wild),         kartu(hitam, wild),
        kartu(hitam, wildDrawFour), kartu(hitam, wildDrawFour),
        kartu(hitam, wildDrawFour), kartu(hitam, wildDrawFour),
        kartu(hitam, mimic)
    ],
    gabungList(KartuBerwarna, KartuHitam, Deck).

buatKartuBerwarna([], _, []).
buatKartuBerwarna([W|RestW], Jenis, Hasil) :-
    buatSatuWarna(W, Jenis, KartuW),
    buatKartuBerwarna(RestW, Jenis, RestHasil),
    gabungList(KartuW, RestHasil, Hasil).

buatSatuWarna(_, [], []).
buatSatuWarna(W, [J|RestJ], Hasil) :-
    buatSatuWarna(W, RestJ, RestHasil),
    (integer(J), J =:= 0 ->
        gabungList([kartu(W,J)], RestHasil, Hasil)
    ;
        gabungList([kartu(W,J), kartu(W,J)], RestHasil, Hasil)
    ).

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

% Pecah list codes pada semua kemunculan Sep
pecahPada(_, [], [[]]).
pecahPada(Sep, [Sep|T], [[]|Rest]) :- !, pecahPada(Sep, T, Rest).
pecahPada(Sep, [H|T], [[H|Part]|Rest]) :- pecahPada(Sep, T, [Part|Rest]).

% Pecah list codes pada kemunculan Sep pertama saja
pecahPertama(_, [], [], []).
pecahPertama(Sep, [Sep|T], [], T) :- !.
pecahPertama(Sep, [H|T], [H|R1], R2) :- pecahPertama(Sep, T, R1, R2).

removeLastCode([_], []) :- !.
removeLastCode([H|T], [H|R]) :- removeLastCode(T, R).

% Hapus single quote di awal dan akhir codes jika ada
stripOuterQuotes([39|Rest], Clean) :- removeLastCode(Rest, Clean), !.
stripOuterQuotes(Codes, Codes).

stripPrefix([], Rest, Rest).
stripPrefix([H|PT], [H|AT], Rest) :- stripPrefix(PT, AT, Rest).

mapCodesToAtoms([], []).
mapCodesToAtoms([Codes|T], [Atom|AT]) :-
    stripOuterQuotes(Codes, CleanCodes),
    atom_codes(Atom, CleanCodes),
    mapCodesToAtoms(T, AT).

mapCodesToKartu([], []).
mapCodesToKartu([Codes|T], [kartu(W,J)|KT]) :-
    atom_codes(KartuAtom, Codes),
    splitDash(KartuAtom, W, J),
    mapCodesToKartu(T, KT).

splitDash(Atom, W, J) :-
    atom_codes(Atom, Codes),
    pecahPertama(45, Codes, WCodes, JCodes),
    atom_codes(W, WCodes),
    atom_codes(JAtom, JCodes),
    (atom_number(JAtom, N) -> J = N ; J = JAtom).

parseListAtom(Atom, Hasil) :-
    atom_codes(Atom, [91|Rest]),
    removeLastCode(Rest, InnerCodes),
    (InnerCodes = [] -> Hasil = []
    ;
        pecahPada(44, InnerCodes, Parts),
        mapCodesToAtoms(Parts, Hasil)
    ).

parseListKartu(Atom, Hasil) :-
    atom_codes(Atom, [91|Rest]),
    removeLastCode(Rest, InnerCodes),
    (InnerCodes = [] -> Hasil = []
    ;
        pecahPada(44, InnerCodes, Parts),
        mapCodesToKartu(Parts, Hasil)
    ).

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
    stripOuterQuotes(ValueCodes, CleanValueCodes),
    atom_codes(ValueAtom, CleanValueCodes),
    restore_fakta_ascii(Key, ValueAtom), !.

split_key_value([58|Tail], [], Tail) :- !.
split_key_value([Head|Tail], [Head|KeyTail], Value) :- split_key_value(Tail, KeyTail, Value).

restore_fakta_ascii(arah_permainan, Value) :- !,
    retractall(arahPermainan(_)), assertz(arahPermainan(Value)).

restore_fakta_ascii(warna_aktif, Value) :- !,
    retractall(warnaActive(_)), assertz(warnaActive(Value)).

restore_fakta_ascii(discard_top, Value) :- !,
    splitDash(Value, W, J),
    retractall(kartuTeratas(_,_)), assertz(kartuTeratas(W, J)).

restore_fakta_ascii(urutan_pemain, Value) :- !,
    parseListAtom(Value, List),
    retractall(giliran(_)), assertz(giliran(List)).

restore_fakta_ascii(giliran, Value) :- !,
    retractall(giliranAktifTemp(_)), assertz(giliranAktifTemp(Value)).

restore_fakta_ascii(status_UNI, Value) :- !,
    parseListAtom(Value, List),
    retractall(statusUni(_)), assertz(statusUni(List)).

restore_fakta_ascii(kartu_tersembunyi, Value) :- !,
    atom_codes(Value, Codes),
    pecahPada(45, Codes, [PCodes, WCodes, JCodes]),
    stripOuterQuotes(PCodes, CleanPCodes),
    atom_codes(P, CleanPCodes),
    atom_codes(W, WCodes),
    atom_codes(JAtom, JCodes),
    (atom_number(JAtom, N) -> J = N ; J = JAtom),
    retractall(kartuTersembunyi(P, _)),
    assertz(kartuTersembunyi(P, kartu(W, J))).

restore_fakta_ascii(kartu_aksi_terakhir, Value) :- !,
    atom_codes(Value, Codes),
    pecahPada(45, Codes, [WCodes, JCodes, PCodes]),
    atom_codes(W, WCodes),
    atom_codes(JAtom, JCodes),
    (atom_number(JAtom, N) -> J = N ; J = JAtom),
    stripOuterQuotes(PCodes, CleanPCodes),
    atom_codes(Pemain, CleanPCodes),
    retractall(aksiTerakhir(_,_,_,_)),
    assertz(aksiTerakhir(W, J, Pemain, 0)).

% Key format: kartu('NamaPemain'):
restore_fakta_ascii(Key, Value) :-
    atom_codes(Key, KeyCodes),
    atom_codes('kartu(', PrefixCodes),
    stripPrefix(PrefixCodes, KeyCodes, [39|Rest]),
    removeLastCode(Rest, Temp),
    removeLastCode(Temp, NamaCodes),
    atom_codes(NamaPemain, NamaCodes), !,
    parseListKartu(Value, ListKartu),
    retractall(kartudiTangan(NamaPemain, _)),
    assertz(kartudiTangan(NamaPemain, ListKartu)).

restore_fakta_ascii(_, _).

restoreGiliran :-
    (giliranAktifTemp(GiliranAktif) ->
        giliran(UrutanPemain),
        rotasiKeDepan(UrutanPemain, GiliranAktif, UrutanRotasi),
        retractall(giliran(_)), assertz(giliran(UrutanRotasi)),
        retractall(giliranAktifTemp(_))
    ; true).

restoreStateTetap :-
    retractall(penantangWDF(_)),   assertz(penantangWDF(none)),
    retractall(sudahMainKartu(_)), assertz(sudahMainKartu(false)),
    retractall(statusBluffWDF(_)), assertz(statusBluffWDF(jujur)),
    retractall(giliranKe(_)),      assertz(giliranKe(1)).

restoreTumpukan :-
    giliran(ListPemain),
    buatDeckLengkap(DeckLengkap),
    kumpulkanTerpakai(ListPemain, Terpakai),
    buatSisaDeck(DeckLengkap, Terpakai, SisaDeck),
    retractall(tumpukan_kartu(_)),
    assertz(tumpukan_kartu(SisaDeck)).

loadGame :-
    write('Masukkan nama file yang akan dimuat (diakhiri titik): '),
    read(NamaFile),
    atom_concat(NamaFile, '.txt', NamaFileAtom),
    (catch(open(NamaFileAtom, read, Stream), _, fail) ->
        baca_baris_loop(Stream),
        close(Stream),
        restoreGiliran,
        restoreStateTetap,
        restoreTumpukan,
        giliran([GiliranSekarang|_]),
        write('Status permainan berhasil dimuat dari '), write(NamaFileAtom), write('.'), nl,
        write('Melanjutkan giliran '), write(GiliranSekarang), write('.'), nl
    ;
        write('Error: File '), write(NamaFileAtom), write(' tidak ditemukan.'), nl, fail
    ).
