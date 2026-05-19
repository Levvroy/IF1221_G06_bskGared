:- dynamic(kartudiTangan/2).

nilaiKartu(Jenis, Nilai) :-
    integer(Jenis), !, Nilai = Jenis.

nilaiKartu(skip,10) :- !.
nilaiKartu(reverse,10) :- !.
nilaiKartu(drawTwo,10) :- !.
nilaiKartu(wild,20) :- !.
nilaiKartu(wildDrawFour,20) :- !.
nilaiKartu(mimic,20).

totalPoinKartu([], 0).
totalPoinKartu([kartu(_, Jenis) | Sisa], Total) :-
    nilaiKartu(Jenis, N),
    totalPoinKartu(Sisa, SisaTotal),
    Total is N + SisaTotal.

printKartuList([kartu(W, J)]) :- !,
    write(W), write('-'), write(J).
printKartuList([kartu(W, J) | T]) :-
    write(W), write('-'), write(J), write(' + '),
    printKartuList(T).

printNilaiList([kartu(_, J)]) :- !,
    nilaiKartu(J, N), write(N).
printNilaiList([kartu(_, J) | T]) :-
    nilaiKartu(J, N), write(N), write(' + '),
    printNilaiList(T).

printDetailPoin(Pemain) :-
    kartudiTangan(Pemain, Tangan),
    (   Tangan = []

    /* Kondisi jika pemain sudah tidak memiliki kartu  */
    ->  write(Pemain), write(': kartu habis = 0 poin')

    /* Kondisi jika pemain masih memiliki kartu di tangan */

    ;   write(Pemain), write(': '),
        printKartuList(Tangan), write(' = '),
        printNilaiList(Tangan), write(' = '),
        totalPoinKartu(Tangan, Total),
        write(Total), write(' poin')
    ), nl.
