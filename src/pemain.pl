get_jumlah_pemain(N) :-
    write('Masukkan jumlah pemain: '),
    read(Input),
    (   Input >= 2, Input =< 4
    ->  N = Input
    ;   write('Mohon masukkan angka antara 2 - 4.'), nl,
        get_jumlah_pemain(N)
    ).

get_nama_pemain(N, ListPemain) :-
    get_nama_pemain_loop(1, N, [], ListPemain).

get_nama_pemain_loop(Current, Total, _, Acc) :-
    Current > Total, 
    Acc = Acc, !.

get_nama_pemain_loop(Current, Total, Acc, ListPemain) :-
    Current =< Total,
    write('Masukkan nama pemain '), write(Current), write(': '),
    read(Nama),
    (   member(Nama, Acc)
    ->  handle_duplicate(Acc, NamaValid),
        Next is Current + 1,
        append(Acc, [NamaValid], NewAcc),
        get_nama_pemain_loop(Next, Total, NewAcc, ListPemain)
    ;   Next is Current + 1,
        append(Acc, [Nama], NewAcc),
        get_nama_pemain_loop(Next, Total, NewAcc, ListPemain)
    ).

handle_duplicate(Acc, ValidNama) :-
    write('Nama sudah digunakan. Masukkan nama lain: '),
    read(NamaBaru),
    (   member(NamaBaru, Acc)
    ->  handle_duplicate(Acc, ValidNama)
    ;   ValidNama = NamaBaru
    ).