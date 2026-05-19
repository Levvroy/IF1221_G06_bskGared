:- include('startgame.pl').
:- include('turn.pl').
:- include('poin.pl').
:- include('endGame.pl').
:- include('saveGame.pl').

:- initialization(main).

main :-
    write('\n  Ketik "startGame." untuk memulai permainan. \n  >> '),
    read(Command),
    (
        Command = 'startGame.' ->
        startGame
        ;
        Command = 'exit' ->
        fail
        ;
        main
    ).
