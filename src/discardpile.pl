:- dynamic(discard_pile/1).   
:- dynamic(kartuTeratas/2).

/*Inisiasi Discard Pile*/
inisiasi_discard_pile :-
    findall(kartu(Warna, Jenis), kartu(Warna, Jenis), SemuaKartu),
    length(SemuaKartu, Total),
    
    cari_kartu_awal(SemuaKartu, Total, KartuAwal),
    KartuAwal = kartu(WarnaTerpilih, JenisTerpilih),
    
    retractall(kartuTeratas(_, _)),
    asserta(kartuTeratas(WarnaTerpilih, JenisTerpilih)),
    
    retractall(discard_pile(_)),
    asserta(discard_pile([KartuAwal])),
    
    write('-> Discard pile berhasil diinisiasi.'), nl,
    write('-> Kartu pertama di meja: '), write(WarnaTerpilih), write(' '), write(JenisTerpilih), nl, !.

/*Rekursi pencarian kartu*/
cari_kartu_awal(SemuaKartu, Total, KartuValid) :-
    random(0, Total, Idx),
    Idx1 is Idx + 1,
    ambilIndex(Idx1, SemuaKartu, KartuTerpilih),
    KartuTerpilih = kartu(_, Jenis),

    (   kartu_awal_valid(Jenis)
    ->  KartuValid = KartuTerpilih
    ;   % Jika kartu tidak valid (misal: skip, wild), panggil ulang fungsinya (Rekursi)
        cari_kartu_awal(SemuaKartu, Total, KartuValid)
    ).

/*Validasi kartu awal*/
kartu_awal_valid(Jenis) :-
    \+ member(Jenis, [skip, reverse, drawTwo, wild, wildDrawfour, mimic]).