:- dynamic(giliran/1).
:- dynamic(kartudiTangan/2).
:- dynamic(kartuTeratas/2).
:- dynamic(warnaActive/1).
:- dynamic(tumpukan_kartu/1).
:- dynamic(arahPermainan/1).

/*DEKLARASI FAKTA*/
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

kartu(merah, skip).
kartu(kuning, skip).
kartu(hijau, skip).
kartu(biru, skip).

kartu(merah, reverse).
kartu(kuning, reverse).
kartu(hijau, reverse).
kartu(biru, reverse).

kartu(merah, drawTwo).
kartu(kuning, drawTwo).
kartu(hijau, drawTwo).
kartu(biru, drawTwo).

kartu(hitam, wild).

kartu(hitam, wildDrawFour).

valid_lempar(Warna, Jenis) :-
    warnaActive(WarnaSekarang),
    kartuTeratas(_, JenisTeratas),
    (Warna = WarnaSekarang ; Jenis = JenisTeratas), !.

append_element([], Element, [Element]).
append_element([Head|Tail], Element, [Head|NewTail]) :-
    append_element(Tail, Element, NewTail).

reverse_list(List, Reversed) :-
    reverse_helper(List, [], Reversed).

reverse_helper([], Acc, Acc).
reverse_helper([Head|Tail], Acc, Reversed) :-
    reverse_helper(Tail, [Head|Acc], Reversed).

efek_kartu(skip) :-
    giliran([PemainSekarang, PemainBerikutnya|SisaPemain]),
    write('-> EFEK AKTIF: Kartu Skip!'), nl,
    write('-> Pemain '), write(PemainBerikutnya), write(' kehilangan gilirannya.'), nl,
    append_element(SisaPemain, PemainSekarang, AntreanTmp),
    append_element(AntreanTmp, PemainBerikutnya, AntreanBaru),
    retract(giliran(_)),
    asserta(giliran(AntreanBaru)), !.

efek_kartu(reverse) :-
    giliran(Lama),
    reverse_list(Lama, Baru),
    retract(giliran(_)),
    asserta(giliran(Baru)),
    retract(arahPermainan(ArahLama)),
    (ArahLama = kanan ->
        assertz(arahPermainan(kiri))
    ;
        assertz(arahPermainan(kanan))
    ),
    write('-> EFEK AKTIF: Kartu Reverse!'), nl,
    write('-> Arah permainan dibalikkan!'), nl, !.

efek_kartu(drawTwo) :-
    giliran([PemainSekarang, PemainBerikutnya|SisaPemain]),
    write('-> EFEK AKTIF: Kartu Draw Two!'), nl,
    write('-> Pemain '), write(PemainBerikutnya), write(' harus mengambil 2 kartu dan kehilangan gilirannya.'), nl,
    tumpukan_kartu([Kartu1, Kartu2|SisaDeck]),
    retract(tumpukan_kartu(_)),
    assertz(tumpukan_kartu(SisaDeck)),
    kartudiTangan(PemainBerikutnya, Tangan),
    append_element(Tangan, Kartu1, TanganTmp),
    append_element(TanganTmp, Kartu2, TanganBaru),
    retract(kartudiTangan(PemainBerikutnya, _)),
    assertz(kartudiTangan(PemainBerikutnya, TanganBaru)),
    write('-> (sistem: 2 kartu telah ditambahkan ke tangan '), write(PemainBerikutnya), write(')'), nl,
    append_element(SisaPemain, PemainSekarang, AntreanTmp2),
    append_element(AntreanTmp2, PemainBerikutnya, AntreanBaru),
    retract(giliran(_)),
    asserta(giliran(AntreanBaru)), !.

valid_lempar(hitam, wild) :-
    kartuTeratas(_, JenisTeratas),
    JenisTeratas \= wild,
    JenisTeratas \= wildDrawFour, !.

efek_kartu(wild) :-
    write('-> EFEK AKTIF: Kartu Wild!'), nl,
    write('Pilih warna aktif baru (merah/kuning/hijau/biru): '),
    read(WarnaBaru),
    (WarnaBaru = merah ; WarnaBaru = kuning ; WarnaBaru = hijau ; WarnaBaru = biru), !,
    retract(warnaActive(_)),
    assertz(warnaActive(WarnaBaru)),
    write('-> Warna permainan berhasil diubah menjadi '), write(WarnaBaru), write('.'), nl.

efek_kartu(wild) :-
    write('-> Gagal, warna tidak valid. Gunakan huruf kecil dan akhiri titik.'), nl,
    efek_kartu(wild).

valid_lempar_wild_draw_four(NamaPemain) :-
    kartuTeratas(WarnaMeja, JenisMeja),
    warnaActive(WarnaAktifMeja),
    kartudiTangan(NamaPemain, ListKartuTangan),
    \+ cekAdaKartuValid(WarnaAktifMeja, WarnaMeja, JenisMeja, ListKartuTangan).

cekAdaKartuValid(WarnaAktif, WarnaMeja, JenisMeja, [kartu(W,J)|_]) :-
    (W = WarnaAktif ; W = WarnaMeja ; J = JenisMeja), !.
cekAdaKartuValid(WarnaAktif, WarnaMeja, JenisMeja, [_|Sisa]) :-
    cekAdaKartuValid(WarnaAktif, WarnaMeja, JenisMeja, Sisa).

efek_kartu(wildDrawFour) :-
    giliran([PemainSekarang, PemainBerikutnya|SisaPemain]),
    write('-> EFEK AKTIF: Kartu Wild Draw Four!'), nl,
    write('Masukkan warna aktif baru (merah/kuning/hijau/biru) diakhiri titik: '),
    read(WarnaBaru),
    (WarnaBaru = merah ; WarnaBaru = kuning ; WarnaBaru = hijau ; WarnaBaru = biru), !,
    retract(warnaActive(_)),
    assertz(warnaActive(WarnaBaru)),
    write('-> Warna permainan berhasil diubah menjadi '), write(WarnaBaru), write('.'), nl,
    write('-> Pemain '), write(PemainBerikutnya), write(' mengambil 4 kartu dan kehilangan gilirannya.'), nl,
    tumpukan_kartu([K1, K2, K3, K4|SisaDeck]),
    retract(tumpukan_kartu(_)),
    assertz(tumpukan_kartu(SisaDeck)),
    kartudiTangan(PemainBerikutnya, Tangan),
    append_element(Tangan, K1, T1),
    append_element(T1, K2, T2),
    append_element(T2, K3, T3),
    append_element(T3, K4, TanganBaru),
    retract(kartudiTangan(PemainBerikutnya, _)),
    assertz(kartudiTangan(PemainBerikutnya, TanganBaru)),
    write('-> (sistem: 4 kartu telah ditambahkan ke tangan '), write(PemainBerikutnya), write(')'), nl,
    append_element(SisaPemain, PemainSekarang, AntreanTmp),
    append_element(AntreanTmp, PemainBerikutnya, AntreanBaru),
    retract(giliran(_)),
    asserta(giliran(AntreanBaru)).

efek_kartu(wildDrawFour) :-
    write('-> Gagal, warna tidak valid. Gunakan huruf kecil dan akhiri titik.'), nl,
    efek_kartu(wildDrawFour).

efek_kartu(Jenis) :- integer(Jenis), !.