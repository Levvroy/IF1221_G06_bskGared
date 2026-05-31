:- include('startgame.pl').
:- include('turn.pl').
:- include('poin.pl').
:- include('endGame.pl').
:- include('saveGame.pl').
:- include('loadGame.pl').

:- initialization(main).

printBanner :-
    nl,
    write('================================================================================'), nl,
    write('|                                                                              |'), nl,
    write('|        UUUU            UUUU   NNNN            NNNN   IIIIIIIIIIIIIIII        |'), nl,
    write('|        UUUU            UUUU   NNNNNN          NNNN         IIII              |'), nl,
    write('|        UUUU            UUUU   NNNNNNNN        NNNN         IIII              |'), nl,
    write('|        UUUU            UUUU   NNNN  NNNN      NNNN         IIII              |'), nl,
    write('|        UUUU            UUUU   NNNN    NNNN    NNNN         IIII              |'), nl,
    write('|        UUUU            UUUU   NNNN      NNNN  NNNN         IIII              |'), nl,
    write('|        UUUU            UUUU   NNNN        NNNNNNNN         IIII              |'), nl,
    write('|         UUUU          UUUU    NNNN          NNNNNN         IIII              |'), nl,
    write('|           UUUUUUUUUUUUUU      NNNN            NNNN   IIIIIIIIIIIIIIII        |'), nl,
    write('|                                                                              |'), nl,
    write('================================================================================'), nl,
    write('|                        Permainan Kartu UNI  -  GNU Prolog                    |'), nl,
    write('|              IF1221 Logika Komputasional - Kelompok 06 - bskGared            |'), nl,
    write('|                                                                              |'), nl,
    write('================================================================================'), nl.

printMenu :-
    nl,
    write('  +--------------------------------------------+'), nl,
    write('  |               MENU UTAMA                   |'), nl,
    write('  +--------------------------------------------+'), nl,
    write('  |  startGame.  ->  Mulai permainan baru      |'), nl,
    write('  |  loadGame.   ->  Lanjutkan permainan       |'), nl,
    write('  |  bantuan.    ->  Panduan perintah          |'), nl,
    write('  |  exit.       ->  Keluar dari program       |'), nl,
    write('  +--------------------------------------------+'), nl,
    nl,
    write('  >> Masukkan perintah: ').

printHelp :-
    nl,
    write('  +------------------------------------------------------------+'), nl,
    write('  |                    PANDUAN PERINTAH                        |'), nl,
    write('  +------------------------------------------------------------+'), nl,
    write('  | AKSI UTAMA (hanya 1x per giliran):                         |'), nl,
    write('  |   mainkanKartu(N)       - Mainkan kartu ke-N               |'), nl,
    write('  |   ambilKartu            - Ambil 1 kartu dari deck          |'), nl,
    write('  |   tantang               - Tantang Wild Draw Four           |'), nl,
    write('  |   uni(N)                - Seru UNI lalu mainkan kartu N    |'), nl,
    write('  |   tangkap(NamaPemain)   - Tangkap pemain lupa UNI          |'), nl,
    write('  |   sembunyikanKartu(N)   - Sembunyikan kartu ke-N           |'), nl,
    write('  |   tampilkanKartu        - Tampilkan kartu tersembunyi      |'), nl,
    write('  +------------------------------------------------------------+'), nl,
    write('  | AKSI PENDUKUNG (bebas berapa kali):                        |'), nl,
    write('  |   lihatCommand          - Lihat daftar aksi tersedia       |'), nl,
    write('  |   lihatKartu            - Lihat kartu di tangan            |'), nl,
    write('  |   cekInfo               - Lihat info permainan             |'), nl,
    write('  +------------------------------------------------------------+'), nl,
    write('  | LAINNYA:                                                   |'), nl,
    write('  |   saveGame              - Simpan permainan ke file .txt    |'), nl,
    write('  |   loadGame              - Muat permainan dari file .txt    |'), nl,
    write('  |   exit                  - Kembali ke menu utama            |'), nl,
    write('  +------------------------------------------------------------+'), nl,
    nl.

printSeparator :-
    write('================================================================'), nl.

printGoodbye :-
    nl,
    write('  +--------------------------------------------+'), nl,
    write('  |      Terima kasih telah bermain UNI!       |'), nl,
    write('  |                Sampai jumpa!               |'), nl,
    write('  +--------------------------------------------+'), nl,
    nl.

printUnknownCommand :-
    nl,
    write('  [!] Perintah tidak dikenali.'), nl,
    write('      Ketik bantuan. untuk melihat daftar perintah.'), nl,
    nl.

main :-
    printBanner,
    printSeparator,
    mainLoop.

mainLoop :-
    printMenu,
    read(Command),
    nl,
    handleCommand(Command).

handleCommand(startGame) :- !,
    printSeparator,
    startGame,
    printSeparator,
    gameLoop.

handleCommand(loadGame) :- !,
    printSeparator,
    loadGame,
    printSeparator,
    gameLoop.

handleCommand(bantuan) :- !,
    printHelp,
    mainLoop.

handleCommand(exit) :- !,
    printGoodbye,
    halt.

handleCommand(_) :-
    printUnknownCommand,
    mainLoop.

gameLoop :-
    catch(gameLoopStep, game_over, (printSeparator, mainLoop)).

gameLoopStep :-
    read(Command),
    nl,
    handleGameCommand(Command),
    gameLoopStep.

handleGameCommand(mainkanKartu(N))    :- !, mainkanKartu(N).
handleGameCommand(ambilKartu)          :- !, ambilKartu.
handleGameCommand(tantang)             :- !, tantang.
handleGameCommand(uni(N))              :- !, uni(N).
handleGameCommand(sembunyikanKartu(N)) :- !, sembunyikanKartu(N).
handleGameCommand(tampilkanKartu)      :- !, tampilkanKartu.
handleGameCommand(tangkap(Nama))       :- !, tangkap(Nama).
handleGameCommand(lihatCommand)        :- !, lihatCommand.
handleGameCommand(lihatKartu)          :- !, lihatKartu.
handleGameCommand(cekInfo)             :- !, cekInfo.
handleGameCommand(saveGame)            :- !, printSeparator, saveGame, printSeparator.
handleGameCommand(loadGame)            :- !, printSeparator, loadGame, printSeparator.
handleGameCommand(exit)                :- !, throw(game_over).
handleGameCommand(_)                   :- printUnknownCommand.