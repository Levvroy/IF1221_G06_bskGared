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
│   ├── kartu.pl 
│   ├── startgame.pl   
│   ├── turn.pl        
│   └── main.pl        % File utama, startGame dan endGame
├── docs
└── README.md
```

---

## Fitur Utama

### Setup Permainan
- `startGame` - memulai permainan baru, meminta jumlah pemain (2–4) dan nama masing-masing pemain, mengacak urutan giliran, membagikan 7 kartu acak ke tiap pemain, dan menginisiasi discard pile dengan kartu angka acak

### Aksi Utama (1 per giliran)
- `mainkanKartu(N)` - mainkan kartu ke-N dari tangan pemain yang sedang giliran. Kartu harus valid (cocok warna atau jenis dengan discard top, atau kartu hitam)
- `ambilKartu` - ambil 1 kartu dari deck, lalu giliran otomatis berpindah
- `tantang` - tantang pemain sebelumnya yang memainkan Wild Draw Four. Kalau tantangan berhasil (pemain itu sebenarnya punya kartu valid), pemain itu yang kena hukuman 4 kartu. Kalau gagal, penantang kena 6 kartu
- `uni(N)` - wajib dipakai saat ingin memainkan kartu ke-N yang akan membuat tangan tersisa 1 kartu. Kalau lupa serukan UNI, bisa ditangkap pemain lain

### Aksi Pendukung (bebas berapa kali)
- `tangkap(NamaPemain)` - tangkap pemain yang sudah punya 1 kartu tapi belum serukan UNI. Nama pemain harus diawali huruf kapital, contoh: `tangkap('William')`
- `lihatCommand` - tampilkan daftar aksi yang tersedia pada giliran saat ini
- `lihatKartu` - tampilkan semua kartu di tangan beserta nomor urutnya
- `cekInfo` - tampilkan kartu discard top, urutan pemain, dan jumlah kartu tiap pemain

### Kartu Aksi
- **Skip** - pemain berikutnya kehilangan giliran
- **Reverse** - arah giliran dibalik
- **Draw Two** - pemain berikutnya ambil 2 kartu dan kehilangan giliran
- **Wild** - pemain bebas ganti warna aktif
- **Wild Draw Four** - pemain berikutnya ambil 4 kartu dan kehilangan giliran, plus pemain aktif pilih warna baru. Hanya boleh dimainkan kalau tidak punya kartu valid lain (bisa ditantang)

### End Game
- Permainan otomatis berakhir saat ada pemain yang kartunya habis
- Poin dihitung dari sisa kartu pemain lain:
  - Kartu angka → sesuai angkanya
  - Skip / Reverse / Draw Two → 10 poin
  - Wild / Wild Draw Four → 20 poin
- Pemain dengan poin paling kecil menang

### Save dan Load Game
- `saveGame` - simpan kondisi permainan ke file `.txt`
- `loadGame` - muat kembali permainan dari file `.txt` yang sudah disimpan

---

## Contoh Jalannya Permainan

```
| ?- startGame.

Masukkan jumlah pemain (2-4): 3.
Masukkan nama pemain 1: 'William'.
Masukkan nama pemain 2: 'Razi'.
Masukkan nama pemain 3: 'Adinda'.

Urutan pemain telah diacak.
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
```

---

## Referensi

- GNU Prolog Manual: http://www.gprolog.org/manual/gprolog.html
- UNO Rules: https://www.unorules.com/
=======
