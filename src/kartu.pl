:- dynamic giliran/1.          % Menyimpan urutan list pemain
:- dynamic kartudiTangan/2.    % Menyimpan list kartu pemain
:- dynamic kartuTeratas/2.     % Menyimpan kartu di atas discard pile
:- dynamic warnaAktif/1.       % Menyimpan warna permainan saat ini


/*DEKLARASI FAKTA*/
/*Kartu Angka*/ 
kartu(merah, 0).
kartu(merah, 1). 
kartu(merah, 2). 
kartu(merah, 3). 
kartu(merah, 4).
kartu(merah, 5). 
kartu(merah, 6). 
kartu(merah, 7). 
kartu(merah, 8). 
kartu(merah, 9).

kartu(kuning, 0). 
kartu(kuning, 1). 
kartu(kuning, 2). 
kartu(kuning, 3). 
kartu(kuning, 4).
kartu(kuning, 5). 
kartu(kuning, 6). 
kartu(kuning, 7). 
kartu(kuning, 8). 
kartu(kuning, 9).

kartu(hijau, 0). 
kartu(hijau, 1). 
kartu(hijau, 2). 
kartu(hijau, 3). 
kartu(hijau, 4).
kartu(hijau, 5). 
kartu(hijau, 6). 
kartu(hijau, 7). 
kartu(hijau, 8). 
kartu(hijau, 9).

kartu(biru, 0). 
kartu(biru, 1). 
kartu(biru, 2). 
kartu(biru, 3). 
kartu(biru, 4).
kartu(biru, 5). 
kartu(biru, 6). 
kartu(biru, 7). 
kartu(biru, 8). 
kartu(biru, 9).

/*Kartu Skip*/
kartu(merah, skip).
kartu(kuning, skip).
kartu(hijau, skip).
kartu(biru, skip).

/*Kartu Reverse*/
kartu(merah, reverse).
kartu(kuning, reverse).
kartu(hijau, reverse).
kartu(biru, reverse).

/*Kartu Draw Two*/
kartu(merah, drawTwo).
kartu(kuning, drawTwo).
kartu(hijau, drawTwo).
kartu(biru, drawTwo).

/*Kartu Wild*/
kartu(hitam, wild).

/*Kartu Wild Draw Four*/
kartu(hitam, wildDrawFour).

/*ATURAN*/
/*Validasi untuk Kartu Angka dan Reverse*/
valid_lempar(Warna, Jenis) :-
    warnaAktif(WarnaSekarang),
    kartuTeratas(_, JenisTeratas),
    (Warna = WarnaSekarang ; Jenis = JenisTeratas), !.

/*EFEK KARTU SKIP*/
efek_kartu(skip) :-
    efek_kartu(skip) :-
    giliran([PemainSekarang, PemainBerikutnya | SisaPemain]),
    write('-> EFEK AKTIF: Kartu Skip!'), nl,
    write('-> Pemain '), write(PemainBerikutnya), write(' kehilangan gilirannya.'), nl,
    append(SisaPemain, [PemainSekarang, PemainBerikutnya], AntreanBaru), % Tambahkan baris ini
    retract(giliran(_)),
    asserta(giliran(AntreanBaru)).

/*EFEK KARTU REVERSE*/
efek_kartu(reverse) :-
    giliran(Lama),
    reverse(Lama, Baru),
    retract(giliran(_)),
    asserta(giliran(Baru)),
    write('-> EFEK AKTIF: Kartu Reverse!'), nl.
    write('-> Arah permainan dibalikkan!'), nl, !.

/*EFEK KARTU DRAW TWO*/
efek_kartu(drawTwo) :-
    giliran([PemainSekarang, PemainBerikutnya | SisaPemain]),
    write('-> EFEK AKTIF: Kartu Draw Two!'), nl,
    write('-> Pemain '), write(PemainBerikutnya), write(' harus mengambil 2 kartu dan kehilangan gilirannya.'), nl,
    
    % panggil fungsi ambilKartu
    write('-> (Sistem: Menambahkan 2 kartu ke tangan '), write(PemainBerikutnya), write(')'), nl,
    append(SisaPemain, [PemainSekarang, PemainBerikutnya], AntreanBaru),
    retract(giliran(_)),
    asserta(giliran(AntreanBaru)).

/*EFEK KARTU WILD*/
/*Validasi Kartu Wild*/
valid_lempar(hitam, wild) :-
    kartuTeratas(_, JenisTeratas),
    JenisTeratas \= wild,
    JenisTeratas \= wildDrawFour, !.

efek_kartu(wild) :-
    write('-> EFEK AKTIF: Kartu Wild!'), nl.
    write('Pilih warna aktif baru (merah/kuning/hijau/biru): '),
    read(WarnaBaru),
    ( member(WarnaBaru, [merah, kuning, hijau, biru]) ->
        retract(warnaAktif(_)),
        asserta(warnaAktif(WarnaBaru)),
        write('-> Warna permainan berhasil diubah menjadi '), write(WarnaBaru), write('.'), nl ;
        write('-> Gagal, warna tidak valid. Gunakan huruf kecil dan akhiri titik.'), nl,
        efek_kartu(wild)
    ), !.

/*KARTU WILD DRAW FOUR*/
valid_lempar_wild_draw_four(NamaPemain) :-
    kartuTeratas(WarnaMeja, JenisMeja),
    warnaAktif(WarnaAktifMeja), 
    kartudiTangan(NamaPemain, ListKartuTangan),
    
    \+ member(kartu(WarnaAktifMeja, _), ListKartuTangan),
    \+ member(kartu(WarnaMeja, _), ListKartuTangan),
    % Memastikan TIDAK ADA kartu jenis/angka yang cocok di tangan
    \+ member(kartu(_, JenisMeja), ListKartuTangan).

efek_kartu(wildDrawFour) :-
    giliran([PemainSekarang, PemainBerikutnya | SisaPemain]),
    write('-> EFEK AKTIF: Kartu Wild Draw Four!'), nl,
    write('Masukkan warna aktif baru (merah/kuning/hijau/biru) diakhiri titik: '),
    read(WarnaBaru),
    ( member(WarnaBaru, [merah, kuning, hijau, biru]) ->
        retract(warnaAktif(_)),
        asserta(warnaAktif(WarnaBaru)),
        write('-> Warna permainan berhasil diubah menjadi '), write(WarnaBaru), write('.'), nl,
        
        write('-> Pemain '), write(PemainBerikutnya), write(' mengambil 4 kartu dan kehilangan gilirannya.'), nl,
        
        % panggil fungsi ambilKartu
        write('-> (Sistem: Menambahkan 4 kartu ke tangan '), write(PemainBerikutnya), write(')'), nl,
        append(SisaPemain, [PemainSekarang, PemainBerikutnya], AntreanBaru),
        retract(giliran(_)),
        asserta(giliran(AntreanBaru))
    ;
        write('-> GAGAL: Warna tidak valid. Harap jalankan ulang efek.'), nl
    ).
