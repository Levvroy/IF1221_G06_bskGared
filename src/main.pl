:- include('startgame.pl').
:- include('turn.pl').
:- include('poin.pl').
:- include('endGame.pl').
:- include('saveGame.pl').

:- initialization(main).

main :-
    write('\n  Ketik "startgame." untuk memulai permainan. \n  >> '),
    read(Command),
    (
        Command = 'startgame.' ->
        startGame
        ;
        Command = 'exit' ->
        fail
        ;
        main
    ).