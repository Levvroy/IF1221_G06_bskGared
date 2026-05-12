:- include('kartu.pl').
:- include('pemain.pl').

startGame :-
    retractall(giliran(_)),
    retractall(kartudiTangan(_,_)),
    retractall(kartuTeratas(_,_)),
    retractall(warnaActive(_)),
    retractall(sudahMainKartu(_)),
    retractall(statusUni(_)),
    retractall(penantangWDF(_)),
    assertz(sudahMainKartu(false)),
    assertz(statusUni([])),
    get_jumlah_pemain(N),
    get_nama_pemain(N, ListPemainRaw),
    nl,
    acak_list(ListPemainRaw, ListPemain),
    assertz(giliran(ListPemain)),
    write('Urutan pemain: '), cetak_urutan(ListPemain), write('.'), nl, nl,
    bagi_kartu_semua(ListPemain),
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl, nl,
    init_discard_pile,
    ListPemain = [PemainPertama|_],
    write('Giliran '), write(PemainPertama), write('.'), nl, !.

cetak_urutan([H]) :- write(H), !.
cetak_urutan([H|T]) :- write(H), write(' - '), cetak_urutan(T).

panjang_list([], 0).
panjang_list([_|T], N) :- panjang_list(T, N1), N is N1 + 1.

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

random_kartu(Warna, Jenis) :-
    findall(kartu(W, J), kartu(W, J), SemuaKartu),
    panjang_list(SemuaKartu, Len),
    random(0, Len, Index),
    ambil_elemen_ke(Index, SemuaKartu, kartu(Warna, Jenis), _).

bagi_kartu_semua([]).
bagi_kartu_semua([Pemain|T]) :-
    bagi_kartu_pemain(7, Pemain, []),
    bagi_kartu_semua(T).

bagi_kartu_pemain(0, Pemain, Tangan) :-
    assertz(kartudiTangan(Pemain, Tangan)), !.
bagi_kartu_pemain(N, Pemain, Acc) :-
    N > 0,
    random_kartu(W, J),
    NextN is N - 1,
    bagi_kartu_pemain(NextN, Pemain, [kartu(W,J)|Acc]).

init_discard_pile :-
    random_kartu(W, J),
    ( is_action_card(J) ->
        init_discard_pile
    ;
        assertz(kartuTeratas(W, J)),
        assertz(warnaActive(W)),
        write('Kartu discard top: '), write(W), write('-'), write(J), write('.'), nl, nl
    ).
    
is_action_card(skip).
is_action_card(reverse).
is_action_card(drawTwo).
is_action_card(wild).
is_action_card(wildDrawFour).
is_action_card(mimic).
