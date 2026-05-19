posisiDalam(Elem, [Elem|_], 0) :- !.
posisiDalam(Elem, [_|T], Idx) :-
    posisiDalam(Elem, T, Idx0),
    Idx is Idx0 + 1.

tanpaPemain(_, [], []).
tanpaPemain(P, [P|T], Hasil) :- !, tanpaPemain(P, T, Hasil).
tanpaPemain(P, [H|T], [H|Hasil]) :- tanpaPemain(P, T, Hasil).

urutKecil(Urutan, P1, P2) :-
    kartudiTangan(P1, T1), totalPoinKartu(T1, Poin1), length(T1, J1),
    kartudiTangan(P2, T2), totalPoinKartu(T2, Poin2), length(T2, J2),
    posisiDalam(P1, Urutan, Idx1),
    posisiDalam(P2, Urutan, Idx2),
    (   Poin1 < Poin2  -> true
    ;   Poin1 =:= Poin2, J1 < J2 -> true
    ;   Poin1 =:= Poin2, J1 =:= J2, Idx1 < Idx2
    ).

insertSorted(_, P, [], [P]).
insertSorted(Urutan, P, [H|T], [P,H|T]) :-
    urutKecil(Urutan, P, H), !.
insertSorted(Urutan, P, [H|T], [H|Hasil]) :-
    insertSorted(Urutan, P, T, Hasil).

insertionSort(_, [], []).
insertionSort(Urutan, [H|T], Sorted) :-
    insertionSort(Urutan, T, SortedT),
    insertSorted(Urutan, H, SortedT, Sorted).

printSemuaPoin([]).
printSemuaPoin([P|T]) :-
    printDetailPoin(P),
    printSemuaPoin(T).

cetakRanking([], _).
cetakRanking([P|Sisa], Rank) :-
    kartudiTangan(P, Tangan),
    totalPoinKartu(Tangan, Poin),
    write(Rank), write('. '), write(P),
    write(' ('), write(Poin), write(' poin)'), nl,
    RankBaru is Rank + 1,
    cetakRanking(Sisa, RankBaru).

endGame(Pemenang) :-
    giliran(Urutan),
    tanpaPemain(Pemenang, Urutan, Lainnya),

    write('Permainan selesai! '), write(Pemenang),
    write(' menghabiskan semua kartunya!'), nl, nl,

    write('Berikut perhitungan poin sisa kartu:'), nl,
    printSemuaPoin(Urutan), nl,

    insertionSort(Urutan, Lainnya, LainnyaTerurut),

    write('Urutan pemenang:'), nl,
    cetakRanking([Pemenang | LainnyaTerurut], 1), nl,

    write('Selamat, '), write(Pemenang), write(' menjadi pemenang!'), nl.
