# IF1221_G06_bskGared

Tugas Besar Praktikum IF1221 Logika Komputasional - Kelompok 06

Implementasi permainan **UNI** (versi UNO) menggunakan bahasa pemrograman **Prolog (GNU Prolog)**.

---

## Anggota Kelompok

| Nama | NIM |
|------|-----|
| Jonathan Lewie | 13525136 |
| Muhammad Rafiif Ansyadya | 13525037 |
| Athallah Nanda Andita | 13525148 |
| Diandra Aria Yufana | 13525113 |

---

## Deskripsi Singkat

Program ini adalah implementasi permainan kartu UNI berbasis teks menggunakan GNU Prolog. Pemain bergiliran memainkan kartu, menggunakan efek kartu aksi, dan berusaha menghabiskan semua kartu di tangan mereka lebih cepat dari pemain lain.

Proyek ini dibuat sebagai tugas besar mata kuliah IF1221 Logika Komputasional dan mencakup konsep-konsep seperti rekurens, list, cut, fail, loop, dan file processing di Prolog.

---

## Cara Menjalankan Program

### Prasyarat

- GNU Prolog sudah terinstall di komputer kamu
- Bisa dicek dengan jalankan `gprolog` di terminal, kalau muncul prompt `| ?-` berarti sudah bisa

### Langkah-langkah

1. Clone repo ini
   ```bash
   git clone https://github.com/Levvroy/IF1221_G06_bskGared.git
   cd IF1221_G06_bskGared
   ```

2. Masuk ke folder `src`
   ```bash
   cd src
   ```

3. Jalankan GNU Prolog
   ```bash
   gprolog
   ```

4. Di dalam prompt GNU Prolog, load file utama
   ```prolog
   | ?- consult('main.pl').
   ```

5. Mulai permainan
   ```prolog
   | ?- startGame.
   ```

---

## Struktur Repository

```
IF1221_G06_bskGared
├── src
│   ├── main.pl         % File utama, entry point permainan
│   ├── kartu.pl        % Definisi kartu, validasi, dan efek kartu aksi
│   ├── pemain.pl       % Input dan validasi data pemain
│   ├── startgame.pl    % Inisialisasi dan setup permainan
│   ├── turn.pl         % Logika giliran, aksi pemain, dan perintah game
│   ├── poin.pl         % Perhitungan poin dan tampilan kartu
│   ├── endGame.pl      % Logika akhir permainan dan ranking
│   └── saveGame.pl     % Fitur simpan dan muat permainan
├── docs
└── README.md
```

---

## Fitur Utama

### Setup Permainan
- `startGame` — memulai permainan baru, meminta jumlah pemain (2–4) dan nama masing-masing pemain, mengacak urutan giliran, membagikan 7 kartu acak ke tiap pemain, dan menginisiasi discard pile dengan kartu angka acak

### Aksi Utama (1 per giliran)
- `mainkanKartu(N)` — mainkan kartu ke-N dari tangan pemain yang sedang giliran. Kartu harus valid (cocok warna atau jenis dengan discard top, atau kartu hitam)
- `ambilKartu` — ambil 1 kartu dari deck, lalu giliran otomatis berpindah
- `tantang` — tantang pemain sebelumnya yang memainkan Wild Draw Four. Kalau tantangan berhasil (pemain itu sebenarnya punya kartu valid), pemain itu yang kena hukuman 4 kartu. Kalau gagal, penantang kena 6 kartu
- `uni(N)` — wajib dipakai saat ingin memainkan kartu ke-N yang akan membuat tangan tersisa 1 kartu. Kalau lupa serukan UNI, bisa ditangkap pemain lain
- `sembunyikanKartu(N)` — sembunyikan kartu ke-N dari tangan. Kartu tersembunyi tidak bisa ditebak pemain lain; jika ada yang menangkap pemain dengan kartu tersembunyi, penangkap malah kena penalti 1 kartu
- `tampilkanKartu` — tampilkan kembali kartu yang sedang disembunyikan, lalu giliran berpindah

### Aksi Pendukung (bebas berapa kali)
- `tangkap(NamaPemain)` — tangkap pemain yang sudah punya 1 kartu tapi belum serukan UNI. Nama pemain harus diawali huruf kapital, contoh: `tangkap('William')`
- `lihatCommand` — tampilkan daftar aksi yang tersedia pada giliran saat ini
- `lihatKartu` — tampilkan semua kartu di tangan beserta nomor urutnya (kartu yang sedang disembunyikan akan diberi label `(disembunyikan)`)
- `cekInfo` — tampilkan kartu discard top, urutan pemain, dan jumlah kartu tiap pemain

### Kartu Aksi
- **Skip** — pemain berikutnya kehilangan giliran
- **Reverse** — arah giliran dibalik
- **Draw Two** — pemain berikutnya ambil 2 kartu dan kehilangan giliran
- **Wild** — pemain bebas ganti warna aktif
- **Wild Draw Four** — pemain berikutnya ambil 4 kartu dan kehilangan giliran, plus pemain aktif pilih warna baru. Hanya boleh dimainkan kalau tidak punya kartu valid lain (bisa ditantang)

### End Game
- Permainan otomatis berakhir saat ada pemain yang kartunya habis
- Poin dihitung dari sisa kartu pemain lain:
  - Kartu angka → sesuai angkanya
  - Skip / Reverse / Draw Two → 10 poin
  - Wild / Wild Draw Four → 20 poin
- Pemain diurutkan berdasarkan poin terkecil; pemenang adalah pemain yang menghabiskan kartunya

### Save dan Load Game
- `saveGame` — simpan kondisi permainan saat ini ke file `.txt`, mencakup urutan pemain, arah permainan, kartu di tangan setiap pemain, discard top, warna aktif, status UNI, dan kartu tersembunyi
- `loadGame` — muat kembali permainan dari file `.txt` yang sudah disimpan sebelumnya

---

## Contoh Jalannya Permainan

```
| ?- startGame.

Masukkan jumlah pemain (2-4): 3.
Masukkan nama pemain 1: 'William'.
Masukkan nama pemain 2: 'Razi'.
Masukkan nama pemain 3: 'Adinda'.

Urutan pemain: William - Adinda - Razi.

Setiap pemain mendapatkan 7 kartu acak.
Kartu discard top: merah-6.

Giliran William.
yes

| ?- lihatKartu.

Berikut kartu yang anda miliki.
1. merah-5
2. biru-3
3. hijau-reverse
4. hitam-wild

yes

| ?- mainkanKartu(1).

William memainkan kartu: merah-5.

Giliran Razi.
yes

| ?- sembunyikanKartu(2).

Kartu biru-skip berhasil disembunyikan.

Giliran Adinda.
yes
```

---

## Perubahan pada Milestone 2

- Penambahan file `pemain.pl` untuk mengelola input dan validasi nama pemain (termasuk pengecekan duplikat)
- Penambahan file `saveGame.pl` untuk fitur simpan dan muat kondisi permainan
- Penambahan fitur **Sembunyikan Kartu** (`sembunyikanKartu(N)` dan `tampilkanKartu`) sebagai mekanisme bluff baru
- Penyempurnaan logika `tangkap`: pemain yang menangkap seseorang dengan kartu tersembunyi justru mendapat penalti
- Penambahan pelacakan `kartuTersembunyi` pada sistem penyimpanan game
- Pemisahan logika pemain ke modul tersendiri (`pemain.pl`) agar lebih modular
- Penyempurnaan tampilan `lihatKartu` dengan label `(disembunyikan)` untuk kartu yang sedang disembunyikan

---

## Referensi

- GNU Prolog Manual: http://www.gprolog.org/manual/gprolog.html
- UNO Rules: https://www.unorules.com/
