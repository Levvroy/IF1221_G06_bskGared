:- dynamic(giliran/1).
:- dynamic(kartudiTangan/2).
:- dynamic(kartuTeratas/2).
:- dynamic(warnaActive/1).
:- dynamic(tumpukan_kartu/1).
:- dynamic(sudahMainKartu/1).
:- dynamic(statusUni/1).
:- dynamic(penantangWDF/1).
:- dynamic(statusBluffWDF/1).
:- dynamic(arahPermainan/1).
:- dynamic(kartuTersembunyi/2).
:- dynamic(aksiTerakhir/4).
:- dynamic(giliranKe/1).

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

hurufBesar(Char) :-
    char_code(Char, Code),
    Code >= 65, Code =< 90.

hurufKecil(Char) :-
    char_code(Char, Code),
    Code >= 97, Code =< 122.

toLower(Char, Lower) :-
    char_code(Char, Code),
    Code >= 65, Code =< 90, !,
    LowerCode is Code + 32,
    char_code(Lower, LowerCode).
toLower(Char, Char).

charListToLower([], []).
charListToLower([H|T], [HL|TL]) :-
    toLower(H, HL),
    charListToLower(T, TL).

atomToLower(Atom, AtomLower) :-
    atom_chars(Atom, Chars),
    charListToLower(Chars, CharsLower),
    atom_chars(AtomLower, CharsLower).

ambilSatuDariTumpukan(Pemain, kartu(W,J)) :-
    tumpukan_kartu([kartu(W,J)|Sisa]),
    retract(tumpukan_kartu(_)),
    assertz(tumpukan_kartu(Sisa)),
    kartudiTangan(Pemain, Tangan),
    append_element(Tangan, kartu(W,J), TanganBaru),
    retract(kartudiTangan(Pemain, _)),
    assertz(kartudiTangan(Pemain, TanganBaru)),
    retract(statusUni(ListUni)),
    hapusDariList(Pemain, ListUni, ListUniBaru),
    assertz(statusUni(ListUniBaru)).

ambilNKartuDariTumpukan(_, 0) :- !.
ambilNKartuDariTumpukan(Pemain, N) :-
    N > 0,
    ambilSatuDariTumpukan(Pemain, _),
    N1 is N - 1,
    ambilNKartuDariTumpukan(Pemain, N1).

nextTurn :-
    giliran([Sekarang|Sisa]),
    append_element(Sisa, Sekarang, ListBaru),
    retract(giliran(_)),
    assertz(giliran(ListBaru)),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(false)),
    retract(giliranKe(G)),
    G1 is G + 1,
    assertz(giliranKe(G1)),
    giliran([Berikutnya|_]),
    nl,
    write('----------------------------------------------------------------'), nl,
    write('Giliran '), write(Berikutnya), write('.'), nl,
    write('----------------------------------------------------------------'), nl,
    godsHand.

bisaDimainkan(hitam, _) :- !.
bisaDimainkan(Warna, _) :-
    warnaActive(Warna), !.
bisaDimainkan(_, Jenis) :-
    kartuTeratas(_, JenisTeratas),
    Jenis = JenisTeratas, !.

mainkanKartu(_) :-
    sudahMainKartu(true), !,
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

mainkanKartu(_) :-
    penantangWDF(PemainWDF),
    PemainWDF \= none, !,
    write('[!] Aksi ditolak! Kamu sedang ditargetkan WDF.'), nl,
    write('    Silakan ketik tantang. atau ambilKartu. (untuk menyerah).'), nl.

mainkanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, TanganPemain),
    hitungPanjang(TanganPemain, JumlahKartu),
    (N < 1 ; N > JumlahKartu), !,
    write('[!] Nomor kartu tidak valid.'), nl.

mainkanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, TanganPemain),
    ambilIndex(N, TanganPemain, kartu(Warna, Jenis)),
    \+ bisaDimainkan(Warna, Jenis), !,
    write('[!] Kartu '), write(Warna), write('-'), write(Jenis),
    write(' tidak bisa dimainkan sekarang.'), nl.

mainkanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, TanganPemain),
    ambilIndex(N, TanganPemain, kartu(Warna, Jenis)),
    (Jenis = wildDrawFour ->
        retractall(statusBluffWDF(_)),
        (\+ valid_lempar_wild_draw_four(Pemain) ->
            assertz(statusBluffWDF(curang)),
            write('[Peringatan] Kamu masih punya kartu yang bisa dimainkan. Bisa ditantang lho.'), nl
        ;
            assertz(statusBluffWDF(jujur))
        )
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
    (kartuTersembunyi(Pemain, kartu(Warna, Jenis)) ->
        retract(kartuTersembunyi(Pemain, _))
    ; true),
    (Jenis = wildDrawFour ->
        retract(penantangWDF(_)),
        assertz(penantangWDF(Pemain))
    ; true),
    efek_kartu(Jenis),
    (Jenis \= mimic, is_action_card(Jenis) ->
        giliranKe(G),
        retractall(aksiTerakhir(_,_,_,_)),
        assertz(aksiTerakhir(Warna, Jenis, Pemain, G))
    ; true),
    (TanganBaru = [] ->
        endGame(Pemain)
    ;
        nextTurn
    ).

ambilKartu :-
    sudahMainKartu(true), !,
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

ambilKartu :-
    penantangWDF(PemainWDF),
    PemainWDF \= none, !,
    giliran([Pemain|_]),
    write(Pemain), write(' menyerah dan menerima hukuman 4 kartu dari WDF.'), nl,
    ambilNKartuDariTumpukan(Pemain, 4),
    retract(penantangWDF(_)),
    assertz(penantangWDF(none)),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    nextTurn.

ambilKartu :-
    giliran([Pemain|_]),
    ambilSatuDariTumpukan(Pemain, kartu(W,J)),
    write(Pemain), write(' mendapatkan kartu: '), write(W), write('-'), write(J), write('.'), nl,
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    nextTurn.

tantang :-
    sudahMainKartu(true), !,
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

tantang :-
    penantangWDF(none), !,
    write('[!] Tidak ada yang bisa ditantang sekarang.'), nl.

tantang :-
    penantangWDF(PemainWDF),
    giliran([Penantang|_]),
    statusBluffWDF(Status),
    (Status = jujur ->
        write('Tantangan gagal! '), write(PemainWDF),
        write(' bermain jujur karena tidak punya kartu valid saat melempar WDF.'), nl,
        write(Penantang), write(' mengambil 6 kartu penalti (4 kartu WDF + 2 denda) dan kehilangan gilirannya.'), nl,
        ambilNKartuDariTumpukan(Penantang, 6),
        retract(penantangWDF(_)),
        assertz(penantangWDF(none)),
        retract(sudahMainKartu(_)),
        assertz(sudahMainKartu(true)),
        nextTurn
    ;
        write('Tantangan berhasil! '), write(PemainWDF),
        write(' curang karena diam-diam masih punya kartu valid!'), nl,
        write(PemainWDF), write(' dihukum mengambil 4 kartu.'), nl,
        ambilNKartuDariTumpukan(PemainWDF, 4),
        retract(penantangWDF(_)),
        assertz(penantangWDF(none)),
        write('Giliranmu aman. Silakan jalankan aksi normalmu sekarang (mainkanKartu atau ambilKartu).'), nl
    ).

uni(_) :-
    sudahMainKartu(true), !,
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

uni(_) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    hitungPanjang(Tangan, Jumlah),
    Jumlah =\= 2, !,
    write('[!] uni hanya bisa dipakai saat kamu punya tepat 2 kartu.'), nl.

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
    sudahMainKartu(true), !,
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

tangkap(NamaPemain) :-
    atom_chars(NamaPemain, [H|_]),
    \+ hurufBesar(H),
    \+ hurufKecil(H), !,
    write('[!] Nama pemain tidak valid.'), nl,
    write('    Contoh: tangkap(\'William\').'), nl.

tangkap(NamaPemain) :-
    atom_chars(NamaPemain, [H|_]),
    \+ hurufBesar(H), !,
    write('[!] Nama pemain harus diawali huruf kapital.'), nl,
    write('    Contoh: tangkap(\'William\').'), nl.

tangkap(NamaPemain) :-
    giliran([Penangkap|_]),
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(true)),
    (kartudiTangan(NamaPemain, _) ->
        NamaTarget = NamaPemain
    ;
        atomToLower(NamaPemain, NamaLower),
        kartudiTangan(NamaLower, _),
        NamaTarget = NamaLower
    ),
    kartudiTangan(NamaTarget, TanganTarget),
    hitungPanjang(TanganTarget, JumlahKartu),
    statusUni(ListUni),
    (kartuTersembunyi(NamaTarget, _) ->
        write('Terdapat kartu yang disembunyikan oleh '), write(NamaTarget), write('.'), nl,
        write('Perintah tangkap tidak valid. '), write(Penangkap), write(' mendapatkan 1 kartu penalti.'), nl,
        ambilNKartuDariTumpukan(Penangkap, 1)
    ;
        (JumlahKartu =:= 1, \+ cekAnggota(NamaTarget, ListUni) ->
            write('Tertangkap! '), write(NamaTarget), write(' lupa serukan UNI!'), nl,
            write(NamaTarget), write(' mengambil 2 kartu penalti.'), nl,
            ambilNKartuDariTumpukan(NamaTarget, 2)
        ;
            write('Tangkapan gagal. '), write(Penangkap), write(' mengambil 1 kartu penalti.'), nl,
            ambilNKartuDariTumpukan(Penangkap, 1)
        )
    ).

tangkap(NamaPemain) :-
    atomToLower(NamaPemain, NamaLower),
    \+ kartudiTangan(NamaPemain, _),
    \+ kartudiTangan(NamaLower, _), !,
    write('[!] Pemain tidak ditemukan. Pastikan nama sudah benar.'), nl,
    retract(sudahMainKartu(_)),
    assertz(sudahMainKartu(false)).

sembunyikanKartu(_) :-
    sudahMainKartu(true), !,
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

sembunyikanKartu(_) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    hitungPanjang(Tangan, Jumlah),
    Jumlah =< 1, !,
    write('[!] Tidak bisa menyembunyikan kartu saat hanya punya 1 kartu.'), nl.

sembunyikanKartu(_) :-
    giliran([Pemain|_]),
    kartuTersembunyi(Pemain, _), !,
    write('[!] Kamu sudah punya kartu yang sedang disembunyikan.'), nl.

sembunyikanKartu(N) :-
    giliran([Pemain|_]),
    kartudiTangan(Pemain, Tangan),
    hitungPanjang(Tangan, Jumlah),
    (N < 1 ; N > Jumlah), !,
    write('[!] Nomor kartu tidak valid.'), nl.

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
    write('[!] Kamu sudah melakukan aksi utama di giliran ini.'), nl.

tampilkanKartu :-
    giliran([Pemain|_]),
    \+ kartuTersembunyi(Pemain, _), !,
    write('[!] Kamu tidak sedang menyembunyikan kartu apapun.'), nl.

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
    write('================================================================'), nl,
    write('                     DAFTAR AKSI                               '), nl,
    write('================================================================'), nl,
    write('Aksi utama (hanya 1x per giliran):'), nl,
    (Status = false ->
        write('  1. mainkanKartu(N)      - Mainkan kartu ke-N'), nl,
        write('  2. ambilKartu           - Ambil 1 kartu dari deck'), nl,
        write('  3. tantang              - Tantang Wild Draw Four'), nl,
        write('  4. uni(N)               - Seru UNI lalu mainkan kartu N'), nl,
        write('  5. tangkap(NamaPemain)  - Tangkap pemain lupa UNI'), nl,
        write('  6. sembunyikanKartu(N)  - Sembunyikan kartu ke-N'), nl,
        write('  7. tampilkanKartu       - Tampilkan kartu tersembunyi'), nl
    ;
        write('  (sudah digunakan pada giliran ini)'), nl
    ),
    nl,
    write('Aksi pendukung (bebas berapa kali):'), nl,
    write('  1. lihatCommand         - Lihat daftar aksi ini'), nl,
    write('  2. lihatKartu           - Lihat kartu di tangan'), nl,
    write('  3. cekInfo              - Lihat info permainan'), nl,
    write('================================================================'), nl.

lihatKartu :-
    giliran([Pemain|_]),
    nl,
    write('================================================================'), nl,
    write('Berikut kartu yang anda miliki.'), nl,
    write('================================================================'), nl,
    kartudiTangan(Pemain, Tangan),
    cetakKartuDenganStatus(Tangan, 1, Pemain),
    write('================================================================'), nl.

cetakKartuDenganStatus([], _, _).
cetakKartuDenganStatus([kartu(W,J)|T], N, Pemain) :-
    write('  '), write(N), write('. '), write(W), write('-'), write(J),
    (kartuTersembunyi(Pemain, kartu(W,J)) -> write(' (disembunyikan)') ; true),
    nl,
    N1 is N + 1,
    cetakKartuDenganStatus(T, N1, Pemain).

cekInfo :-
    kartuTeratas(W, J),
    nl,
    write('================================================================'), nl,
    write('                   INFO PERMAINAN                              '), nl,
    write('================================================================'), nl,
    write('Kartu discard top : '), write(W), write('-'), write(J), write('.'), nl,
    nl,
    giliran(ListPemain),
    write('Urutan pemain     : '),
    cetakUrutan(ListPemain), nl,
    write('----------------------------------------------------------------'), nl,
    cetakInfoPemain(ListPemain, 1),
    write('================================================================'), nl.

cetakUrutan([X]) :- write(X), nl, !.
cetakUrutan([H|T]) :- write(H), write(' - '), cetakUrutan(T).

cetakInfoPemain([], _).
cetakInfoPemain([P|T], N) :-
    kartudiTangan(P, Tangan),
    hitungPanjang(Tangan, JumlahTotal),
    (kartuTersembunyi(P, _) ->
        JumlahTerlihat is JumlahTotal - 1
    ;
        JumlahTerlihat = JumlahTotal
    ),
    write('Nama pemain '), write(N), write(' : '), write(P), nl,
    write('Jumlah kartu    : '), write(JumlahTerlihat), nl,
    nl,
    N1 is N + 1,
    cetakInfoPemain(T, N1).