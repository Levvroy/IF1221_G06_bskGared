:- include('startgame.pl').
:- include('turn.pl').
:- include('poin.pl').
:- include('endGame.pl').
:- include('saveGame.pl').
:- include('loadGame.pl').

:- initialization(main).

printBanner :-
    nl,
    write('╔══════════════════════════════════════════════════════════════════════════════╗'), nl,
    write('║    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    ║'), nl,
    write('║    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    ║'), nl,
    write('║    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    ║'), nl,
    write('║    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&&&&&&&&&&&;+Xx: X&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&&&&&&&&&&X.Xx.XXx:.&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&      ║'), nl,
    write('║      &&&&&&&&&&&&&&&&&&&&&&&&&&$xXX;xXXXX;.&&&&&&&&&&&&&&&&&&&$&&&&&&&&      ║'), nl,
    write('║      &&&&&&&&&&&&&&&&&&&&&&&&&&;$XXx+:;xX;.......  .;X&&&&&&&  :::&&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&&&&: ...:+.;;;;;X;           ..  .$&&&&. . ;&&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&$. ..    .$X+..;Xx;              .  .x$;;;..x&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&...        .XX;;XXx;           .::::::. :++;:&&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&..          xXX+XXx:           .:;++;:  ;;;;+&&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&+.           ;;;:;.             ::;;+;;:    x&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&$                           ...   .:::..    $&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&;                                 ...;:   .&&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&:..                                :::;;;: X:::&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&; .              .::;;.;;;:.:.        .:;x;;....:&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&...      ..;;:;;;;;;;;;:;;;+;:+;;;;:;:  . ::::: &&&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&:.     ..:;+;;.++;;;+x;x;xxx+:;;;;;:;;;;:.       x&&&&&      ║'), nl,
    write('║     &&&&&&&&&&$XX      .:.;+xx+;;xxxxx++:&..:;;:;;;;:;;;;;;.      &&&&&&     ║'), nl,
    write('║     &&&&&&&&$$$$$x.    ;;:;;:;:X.++;;x+;;$&$.;;;;;;;::;;;;;;:.   +&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&X$$&$X&$.;;:;;;;;&&;;;;:;;;:&&$$x...;:.;;;;;;. ..  .&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&$$&&$&&$.;;.;;;:&&&X;;; ;;;+&;.:...:...;;;;;:....    .;;.     ║'), nl,
    write('║     &&&&&&&&&&&&&X&&X&X:;;.:.:&$$&&$;;;;..;;.x.::. xX.:;;;;.  . ;:    .      ║'), nl,
    write('║     &&&&&&&&&&&&&&xX$$X:;;;.:.:;;. .&;;;;:$&&x.x&;;+&;;;;;;:  .;;;;;. .      ║'), nl,
    write('║     &&&&&&&&&&&&&&&XX&x.;;;:.;$x..X;X&&X:.:x&$;xxx;&x;;;;;;;:;  ...  X&      ║'), nl,
    write('║     &&&&&&&&&&&&&x:.   .;;;;:x&x;;X+X&&&&&&&&&&$X&$;;;;;;;;::.;;;;;:.$$      ║'), nl,
    write('║     &&&&&&&&&&&&&&+.    +;;;;;$&x++$&&&&&&&&&&&&&&&&&$;.;;;;...:;;;;;;;.     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&X   .+;; .X$$$&&&&&&+;x+&&&&&&&X::. .....:;;:;;;;;;      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&+:;;..:.$$$$&&x$$$;XXXXX&&&&&+ ..:;;;.  ;;;;.  ;$      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&& ... ....x&&+xxx;x$xXXXX&&x +:;;;;;.x&&. .:;;;;;:.      ║'), nl,
    write('║     &&&&&&&&&&&&&&&X. .......;:.  :&&&&x$Xx+:   ;;;:;;  &&&&$ .;:::::::      ║'), nl,
    write('║    &&&&&&&&&&&&& .......... ;;;:  .&&&&$; ..  ;;;;::;: &&&&&x.::::::.:.x     ║'), nl,
    write('║    &&&&&&&&&&&&X  .. .... ;;;:     .$X        :::::.:: &&&;.::.:::.:. &&     ║'), nl,
    write('║     &&&&&&&&&&&&&&;....:::::.        ;   .. .. .... ...::::..::  .&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&....                    ...... .....+;  .  .:. $&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&; ....   .          ..........:+.  .&&&&&&&x:x&&&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&Xx+x&&&&&.  ;x&$x;::;;x$&&&&&&&&&&&&&&&&&&&&&&&&&&      ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     ║'), nl,
    write('║     &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     ║'), nl,
    write('╠══════════════════════════════════════════════════════════════════════════════╣'), nl,
    write('║                                                                              ║'), nl,
    write('║                            ██╗   ██╗███╗   ██╗██╗                            ║'), nl,
    write('║                            ██║   ██║████╗  ██║██║                            ║'), nl,
    write('║                            ██║   ██║██╔██╗ ██║██║                            ║'), nl,
    write('║                            ██║   ██║██║╚██╗██║██║                            ║'), nl,
    write('║                            ╚██████╔╝██║ ╚████║██║                            ║'), nl,
    write('║                             ╚═════╝ ╚═╝  ╚═══╝╚═╝                            ║'), nl,
    write('║                                                                              ║'), nl,
    write('╠══════════════════════════════════════════════════════════════════════════════╣'), nl,
    write('║                  Permainan Kartu UNI  -  GNU Prolog Edition                  ║'), nl,
    write('║            IF1221 Logika Komputasional  |  Kelompok 06 - bskGared            ║'), nl,
    write('║                                                                              ║'), nl,
    write('╚══════════════════════════════════════════════════════════════════════════════╝'), nl,
    nl.

printMenu :-
    write('  ┌─────────────────────────────────────────────┐'), nl,
    write('  │              MENU UTAMA                     │'), nl,
    write('  ├─────────────────────────────────────────────┤'), nl,
    write('  │  startGame.   →  Mulai permainan baru       │'), nl,
    write('  │  loadGame.    →  Lanjutkan permainan        │'), nl,
    write('  │  help.        →  Panduan perintah           │'), nl,
    write('  │  exit.        →  Keluar dari program        │'), nl,
    write('  └─────────────────────────────────────────────┘'), nl,
    nl,
    write('  Masukkan perintah: ').

printHelp :-
    nl,
    write('  ╔══════════════════════════════════════════════════════════╗'), nl,
    write('  ║                   PANDUAN PERINTAH                      ║'), nl,
    write('  ╠══════════════════════════════════════════════════════════╣'), nl,
    write('  ║  AKSI UTAMA (1x per giliran):                           ║'), nl,
    write('  ║   mainkanKartu(N).      Mainkan kartu ke-N              ║'), nl,
    write('  ║   ambilKartu.           Ambil 1 kartu dari deck         ║'), nl,
    write('  ║   tantang.              Tantang Wild Draw Four          ║'), nl,
    write('  ║   uni(N).               Seru UNI lalu mainkan kartu N   ║'), nl,
    write('  ║   sembunyikanKartu(N).  Sembunyikan kartu ke-N          ║'), nl,
    write('  ║   tampilkanKartu.       Tampilkan kartu tersembunyi     ║'), nl,
    write('  ╠══════════════════════════════════════════════════════════╣'), nl,
    write('  ║  AKSI PENDUKUNG (bebas berapa kali):                    ║'), nl,
    write('  ║   tangkap(\'Nama\').      Tangkap pemain lupa UNI       ║'), nl,
    write('  ║   lihatCommand.         Lihat daftar aksi tersedia      ║'), nl,
    write('  ║   lihatKartu.           Lihat kartu di tangan           ║'), nl,
    write('  ║   cekInfo.              Lihat info permainan            ║'), nl,
    write('  ╠══════════════════════════════════════════════════════════╣'), nl,
    write('  ║  LAINNYA:                                               ║'), nl,
    write('  ║   saveGame.             Simpan permainan ke file        ║'), nl,
    write('  ║   loadGame.             Muat permainan dari file        ║'), nl,
    write('  ╚══════════════════════════════════════════════════════════╝'), nl,
    nl.

printSeparator :-
    write('  ──────────────────────────────────────────────────────────'), nl.

printGoodbye :-
    nl,
    write('  ╔══════════════════════════════════════════════════════════╗'), nl,
    write('  ║                                                          ║'), nl,
    write('  ║            Terima kasih telah bermain UNI!               ║'), nl,
    write('  ║                     Sampai jumpa!                        ║'), nl,
    write('  ║                                                          ║'), nl,
    write('  ╚══════════════════════════════════════════════════════════╝'), nl,
    nl.

printUnknownCommand :-
    nl,
    write('     Perintah tidak dikenali.'), nl,
    write('     Ketik "help." untuk melihat daftar perintah.'), nl,
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
    mainLoop.

handleCommand(loadGame) :- !,
    printSeparator,
    loadGame,
    printSeparator,
    mainLoop.

handleCommand(help) :- !,
    printHelp,
    mainLoop.

handleCommand(exit) :- !,
    printGoodbye.

handleCommand(_) :-
    printUnknownCommand,
    mainLoop.