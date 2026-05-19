get_jumlah_pemain(N) :-
    write('Masukkan jumlah pemain: '),
    read(Input),
    (integer(Input), Input >= 2, Input =< 4 ->
        N = Input
    ;
        write('Mohon masukkan angka antara 2 - 4.'), nl,
        get_jumlah_pemain(N)
    ).

get_nama_pemain(N, ListPemain) :-
    get_nama_pemain_loop(1, N, [], ListPemain).

get_nama_pemain_loop(Current, Total, Acc, Acc) :-
    Current > Total, !.

get_nama_pemain_loop(Current, Total, Acc, ListPemain) :-
    Current =< Total,
    write('Masukkan nama pemain '), write(Current), write(': '),
    read(Nama),
    (cekAdaDiList(Nama, Acc) ->
        handle_duplicate(Acc, NamaValid),
        Next is Current + 1,
        tambahKeList(Acc, NamaValid, NewAcc),
        get_nama_pemain_loop(Next, Total, NewAcc, ListPemain)
    ;
        Next is Current + 1,
        tambahKeList(Acc, Nama, NewAcc),
        get_nama_pemain_loop(Next, Total, NewAcc, ListPemain)
    ).

handle_duplicate(Acc, ValidNama) :-
    write('Nama sudah digunakan. Masukkan nama lain: '),
    read(NamaBaru),
    (cekAdaDiList(NamaBaru, Acc) ->
        handle_duplicate(Acc, ValidNama)
    ;
        ValidNama = NamaBaru
    ).

cekAdaDiList(X, [X|_]) :- !.
cekAdaDiList(X, [_|T]) :- cekAdaDiList(X, T).

tambahKeList([], X, [X]).
tambahKeList([H|T], X, [H|Hasil]) :-
    tambahKeList(T, X, Hasil).