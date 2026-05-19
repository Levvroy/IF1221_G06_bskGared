:- include('kartu.pl').
:- include('pemain.pl').

startGame :-
    retractall(giliran(_)),
    retractall(kartudiTangan(_,_)),
    retractall(kartuTeratas(_,_)),
    retractall(warnaActive(_)),
    retractall(tumpukan_kartu(_)),
    retractall(sudahMainKartu(_)),
    retractall(statusUni(_)),
    retractall(penantangWDF(_)),
    retractall(arahPermainan(_)),
    retractall(kartuTersembunyi(_,_)), % penambahan dari spesifikasi bonus
    get_jumlah_pemain(N),
    get_nama_pemain(N, ListPemainRaw),
    nl,
    buatDeckLengkap(DeckAwal),
    acak_list(DeckAwal, DeckAcak),
    bagiKartuSemua(ListPemainRaw, DeckAcak, DeckSisa),
    acak_list(ListPemainRaw, ListPemain),
    assertz(giliran(ListPemain)),
    assertz(sudahMainKartu(false)),
    assertz(statusUni([])),
    assertz(penantangWDF(none)),
    assertz(arahPermainan(kanan)),
    write('Urutan pemain: '), cetak_urutan(ListPemain), write('.'), nl, nl,
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl, nl,
    initDiscardPile(DeckSisa, DeckFinal),
    assertz(tumpukan_kartu(DeckFinal)),
    ListPemain = [PemainPertama|_],
    write('Giliran '), write(PemainPertama), write('.'), nl, !.

buatDeckLengkap(Deck) :-
    findall(kartu(W,J), kartu(W,J), Deck).

bagiKartuSemua([], Deck, Deck).
bagiKartuSemua([Pemain|SisaPemain], DeckAwal, DeckAkhir) :-
    ambilNKartu(7, DeckAwal, Tangan, DeckSisa),
    assertz(kartudiTangan(Pemain, Tangan)),
    bagiKartuSemua(SisaPemain, DeckSisa, DeckAkhir).

ambilNKartu(0, Deck, [], Deck) :- !.
ambilNKartu(N, [Kartu|Sisa], [Kartu|Tangan], DeckAkhir) :-
    N > 0,
    N1 is N - 1,
    ambilNKartu(N1, Sisa, Tangan, DeckAkhir).

initDiscardPile([kartu(W,J)|Sisa], Sisa) :-
    \+ is_action_card(J), !,
    assertz(kartuTeratas(W, J)),
    assertz(warnaActive(W)),
    write('Kartu discard top: '), write(W), write('-'), write(J), write('.'), nl, nl.

initDiscardPile([Kartu|Sisa], DeckFinal) :-
    append_element(Sisa, Kartu, DeckBaru),
    initDiscardPile(DeckBaru, DeckFinal).

cetak_urutan([H]) :- write(H), !.
cetak_urutan([H|T]) :- write(H), write(' - '), cetak_urutan(T).

panjang_list([], 0).
panjang_list([_|T], N) :-
    panjang_list(T, N1),
    N is N1 + 1.

ambil_elemen_ke(0, [H|T], H, T) :- !.
ambil_elemen_ke(N, [H|T], X, [H|Sisa]) :-
    N > 0,
    N1 is N - 1,
    ambil_elemen_ke(N1, T, X, Sisa).

acak_list([], []).
acak_list(List, [X|ListAcak]) :-
    panjang_list(List, Len),
    random(0, Len, Index),
    ambil_elemen_ke(Index, List, X, SisaList),
    acak_list(SisaList, ListAcak).

is_action_card(skip).
is_action_card(reverse).
is_action_card(drawTwo).
is_action_card(wild).
is_action_card(wildDrawFour).
is_action_card(mimic).