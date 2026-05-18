urutPemain(Urutan, Order, P1, P2) :-
    kartudiTangan(P1, T1), totalPoinKartu(T1, Poin1), length(T1, J1),
    kartudiTangan(P2, T2), totalPoinKartu(T2, Poin2), length(T2, J2),
    nth0(Idx1, Urutan, P1),
    nth0(Idx2, Urutan, P2),
    (   Poin1 < Poin2 -> Order = (<)
    ;   Poin1 > Poin2 -> Order = (>)
    ;   J1    < J2    -> Order = (<)
    ;   J1    > J2    -> Order = (>)
    ;   Idx1  < Idx2  -> Order = (<)
    ;                    Order = (>)
    ).

cetakRanking([], _).
cetakRanking([P | Sisa], Rank) :-
    kartudiTangan(P, Tangan),
    totalPoinKartu(Tangan, Poin),
    write(Rank), write('. '), write(P),
    write(' ('), write(Poin), write(' poin)'), nl,
    RankBaru is Rank + 1,
    cetakRanking(Sisa, RankBaru).

endGame(Pemenang) :-
    giliran(Urutan),
    findall(P, kartudiTangan(P, _), SemuaPemain),

    write('Permainan selesai! '), write(Pemenang),
    write(' menghabiskan semua kartunya!'), nl, nl,

    write('Berikut perhitungan poin sisa kartu:'), nl,
    maplist(cetakDetailPoin, Urutan), nl,

    findall(P, (member(P, SemuaPemain), P \= Pemenang), Lainnya),
    predsort(urutPemain(Urutan), Lainnya, LainnyaTerurut),

    write('Urutan pemenang:'), nl,
    cetakRanking([Pemenang | LainnyaTerurut], 1), nl,

    write('Selamat, '), write(Pemenang), write(' menjadi pemenang!'), nl.
