:- dynamic giliran/1.
:- dynamic kartudiTangan/2.
:- dynamic kartuTeratas/2.
:- dynamic warnaActive/1.
:- dynamic tumpukan_kartu/1.
:- dynamic sudahMainKartu/1.
:- dynamic statusUni/1.
:- dynamic penantangWDF/1.
:- dynamic arahPermainan/1.
:- dynamic kartuTersembunyi/2.

ambilIndex(1, [H|_], H) :- !.
ambilIndex(N, [_|T], X) :-
    N > 1,
    N1 is N - 1,
    ambilIndex(N1, T, X).

hapusIndex(1, [_|T], T) :- !.
hapusIndex(N, [H|T], [H|Hasil]) :-
    N > 1,
    N1 is N - 1,
    hapusIndex(N1, T, Hasil).

hitungPanjang([], 0).
hitungPanjang([_|T], N) :-
    hitungPanjang(T, N1),
    N is N1 + 1.

hapusDariList(_, [], []).
hapusDariList(X, [X|T], T) :- !.
hapusDariList(X, [H|T], [H|Hasil]) :-
    hapusDariList(X, T, Hasil).

cekAnggota(X, [X|_]) :- !.
cekAnggota(X, [_|T]) :- cekAnggota(X, T).

ambilSatuDariTumpukan(Pemain) :-
    tumpukan_kartu([Kartu|Sisa]),
    retract(tumpukan_kartu(_)),
    assertz(tumpukan_kartu(Sisa)),
    kartudiTangan(Pemain, Tangan),
    append_element(Tangan, Kartu, TanganBaru),
    retract(kartudiTangan(Pemain, _)),
    assertz(kartudiTangan(Pemain, TanganBaru)).

ambilNKartuDariTumpukan(_, 0) :- !.
ambilNKartuDariTumpukan(Pemain, N) :-
    N > 0,
    ambilSatuDariTumpukan(Pemain),
    N1 is N - 1,
    ambilNKartuDariTumpukan(Pemain, N1).

nextTurn :-
    giliran([Sekarang|Sisa]),
    append_element(Sisa, Sekarang, ListBaru),
    retract(giliran(_)),
    assertz(giliran(ListBaru)),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(false)),
    retract(penantangWDF(_)),
    assertz(penantangWDF(none)),
    giliran([Berikutnya|_]),
    write('Giliran '), write(Berikutnya), write('.'), nl.

bisaDimainkan(hitam, _) :- !.

bisaDimainkan(Warna, _) :-
    warnaActive(Warna), !.

bisaDimainkan(_, Jenis) :-
    kartuTeratas(_, JenisTeratas),
    Jenis = JenisTeratas, !.

mainkanKartu(_) :-
    sudahMainKartu(true), !,
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl.

mainkanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, TanganPemain),
    hitungPanjang(TanganPemain, JumlahKartu),
    (N < 1 ; N > JumlahKartu), !,
    write('Nomor kartu tidak valid.'), nl.

mainkanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, TanganPemain),
    ambilIndex(N, TanganPemain, kartu(Warna, Jenis)),
    \+ bisaDimainkan(Warna, Jenis), !,
    write('Kartu '), write(Warna), write('-'), write(Jenis),
    write(' tidak bisa dimainkan sekarang.'), nl.

mainkanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, TanganPemain),
    ambilIndex(N, TanganPemain, kartu(Warna, Jenis)),
    (Jenis = wildDrawFour ->
        (\+ valid_lempar_wild_draw_four(Pemain) ->
            write('[Peringatan] Kamu masih punya kartu yang bisa dimainkan. Bisa ditantang lho.'), nl
        ; true)
    ; true),
    hapusIndex(N, TanganPemain, TanganBaru),
    retract(kartudiTangan(Pemain, _)),
    assertz(kartudiTangan(Pemain, TanganBaru)),
    retract(kartuTeratas(_, _)),
    assertz(kartuTeratas(Warna, Jenis)),
    retract(warnaActive(_)),
    assertz(warnaActive(Warna)),
    write(Pemain), write(' memainkan kartu: '),
    write(Warna), write('-'), write(Jenis), write('.'), nl,
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    retract(statusUni(ListUni)),
    hapusDariList(Pemain, ListUni, ListUniBaru),
    assertz(statusUni(ListUniBaru)),
    (kartuTersembunyi(Pemain, kartu(Warna, Jenis)) ->
        retract(kartuTersembunyi(Pemain, _))
    ; true),
    (Jenis = wildDrawFour ->
        retract(penantangWDF(_)),
        assertz(penantangWDF(Pemain))
    ; true),
    efek_kartu(Jenis),
    (TanganBaru = [] ->
        endGame(Pemain)
    ;
        nextTurn
    ).

ambilKartu :-
    sudahMainKartu(true), !,
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl.

ambilKartu :-
    giliran([Pemain|_]),
    ambilSatuDariTumpukan(Pemain),
    write(Pemain), write(' mengambil 1 kartu.'), nl,
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    nextTurn.

tantang :-
    sudahMainKartu(true), !,
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl.

tantang :-
    penantangWDF(none), !,
    write('Tidak ada yang bisa ditantang sekarang.'), nl.

tantang :-
    penantangWDF(PemainWDF),
    giliran([Penantang|_]),
    (valid_lempar_wild_draw_four(PemainWDF) ->
        write('Tantangan gagal! '),
        write(PemainWDF), write(' memang tidak punya kartu valid.'), nl,
        write(Penantang), write(' mengambil 6 kartu.'), nl,
        ambilNKartuDariTumpukan(Penantang, 6)
    ;
        write('Tantangan berhasil! '),
        write(PemainWDF), write(' ternyata masih punya kartu yang bisa dimainkan!'), nl,
        write(PemainWDF), write(' mengambil 4 kartu.'), nl,
        ambilNKartuDariTumpukan(PemainWDF, 4)
    ),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    nextTurn.

uni(_) :-
    sudahMainKartu(true), !,
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl.

uni(_) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    hitungPanjang(Tangan, Jumlah),
    Jumlah =\= 2, !,
    write('uni hanya bisa dipakai saat kamu punya tepat 2 kartu.'), nl.

uni(N) :-
    giliran([Pemain|_]),
    retract(statusUni(ListUni)),
    (cekAnggota(Pemain, ListUni) ->
        ListUniBaru = ListUni
    ;
        append_element(ListUni, Pemain, ListUniBaru)
    ),
    assertz(statusUni(ListUniBaru)),
    write(Pemain), write(' menyerukan UNI!'), nl,
    mainkanKartu(N).

tangkap(_) :-
    giliran([Pemain|_]),
    Pemain = _, !,
    tangkapProses(_).

tangkap(NamaPemain) :-
    atom_chars(NamaPemain, [H|_]),
    \+ char_type(H, upper), !,
    write('Nama pemain harus diawali huruf kapital. Contoh: tangkap(\'William\').'), nl.

tangkap(NamaPemain) :-
    atom_chars(NamaPemain, [H|_]),
    char_type(H, upper),
    atom_string(NamaPemain, NamaStr),
    string_lower(NamaStr, NamaLower),
    atom_string(NamaAtom, NamaLower),
    giliran([Penangkap|_]),
    kartudiTangan(NamaAtom, TanganTarget),
    hitungPanjang(TanganTarget, JumlahKartu),
    statusUni(ListUni),
    (kartuTersembunyi(NamaAtom, _) ->
        write('Terdapat kartu yang disembunyikan oleh '), write(NamaAtom), write('.'), nl,
        write('Perintah tangkap tidak valid. '), write(Penangkap), write(' mendapatkan 1 kartu penalti.'), nl,
        ambilNKartuDariTumpukan(Penangkap, 1)
    ;
        (JumlahKartu =:= 1, \+ cekAnggota(NamaAtom, ListUni) ->
            write('Tertangkap! '), write(NamaAtom), write(' lupa serukan UNI!'), nl,
            write(NamaAtom), write(' mengambil 2 kartu penalti.'), nl,
            ambilNKartuDariTumpukan(NamaAtom, 2)
        ;
            write('Tangkapan gagal. '), write(Penangkap), write(' mengambil 1 kartu penalti.'), nl,
            ambilNKartuDariTumpukan(Penangkap, 1)
        )
    ).

sembunyikanKartu(_) :-
    sudahMainKartu(true), !,
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl.

sembunyikanKartu(_) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    hitungPanjang(Tangan, Jumlah),
    Jumlah =< 1, !,
    write('Tidak bisa menyembunyikan kartu saat hanya punya 1 kartu.'), nl.

sembunyikanKartu(_) :-
    giliran([Pemain|_]),
    kartuTersembunyi(Pemain, _), !,
    write('Kamu sudah punya kartu yang sedang disembunyikan.'), nl.

sembunyikanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    hitungPanjang(Tangan, Jumlah),
    (N < 1 ; N > Jumlah), !,
    write('Nomor kartu tidak valid.'), nl.

sembunyikanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    ambilIndex(N, Tangan, kartu(W,J)),
    assertz(kartuTersembunyi(Pemain, kartu(W,J))),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    write('Kartu '), write(W), write('-'), write(J), write(' berhasil disembunyikan.'), nl,
    nextTurn.

tampilkanKartu :-
    sudahMainKartu(true), !,
    write('Kamu sudah melakukan aksi utama di giliran ini.'), nl.

tampilkanKartu :-
    giliran([Pemain|_]),
    \+ kartuTersembunyi(Pemain, _), !,
    write('Kamu tidak sedang menyembunyikan kartu apapun.'), nl.

tampilkanKartu :-
    giliran([Pemain|_]),
    kartuTersembunyi(Pemain, kartu(W,J)),
    retract(kartuTersembunyi(Pemain, _)),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    write('Kartu '), write(W), write('-'), write(J), write(' ditampilkan kembali.'), nl,
    nextTurn.

lihatCommand :-
    sudahMainKartu(Status), nl,
    write('Aksi utama yang tersedia:'), nl,
    (Status = false ->
        write('1. mainkanKartu(N)'), nl,
        write('2. ambilKartu'), nl,
        write('3. tantang'), nl,
        write('4. uni(N)'), nl,
        write('5. sembunyikanKartu(N)'), nl,
        write('6. tampilkanKartu'), nl
    ;
        write('(sudah digunakan pada giliran ini)'), nl
    ), nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. tangkap(NamaPemain)'), nl,
    write('2. lihatCommand'), nl,
    write('3. lihatKartu'), nl,
    write('4. cekInfo'), nl.

lihatKartu :-
    giliran([Pemain|_]),
    write('Berikut kartu yang anda miliki.'), nl,
    kartudiTangan(Pemain, Tangan),
    cetakKartuDenganStatus(Tangan, 1, Pemain).

cetakKartuDenganStatus([], _, _).
cetakKartuDenganStatus([kartu(W,J)|T], N, Pemain) :-
    write(N), write('. '), write(W), write('-'), write(J),
    (kartuTersembunyi(Pemain, kartu(W,J)) ->
        write(' (disembunyikan)')
    ; true),
    nl,
    N1 is N + 1,
    cetakKartuDenganStatus(T, N1, Pemain).

cekInfo :-
    kartuTeratas(W, J),
    write('Kartu discard top: '), write(W), write('-'), write(J), write('.'), nl, nl,
    giliran(ListPemain),
    write('Urutan pemain: '),
    cetakUrutan(ListPemain), nl, nl,
    cetakInfoPemain(ListPemain, 1).

cetakUrutan([X]) :- write(X), nl, !.
cetakUrutan([H|T]) :- write(H), write(' - '), cetakUrutan(T).

cetakInfoPemain([], _).
cetakInfoPemain([P|T], N) :-
    kartudiTangan(P, Tangan),
    hitungPanjang(Tangan, Jumlah),
    write('Nama pemain '), write(N), write(': '), write(P), nl,
    write('Jumlah kartu : '), write(Jumlah), nl, nl,
    N1 is N + 1,
    cetakInfoPemain(T, N1).