#!/bin/bash

lvl=1
userInput='z'
gameInput=0
cont="Y"
guessCount=1
timesec=1
score=0
quitStatus="2"


cat <<EOF
               ████ █ █ ███ ███ ███ 
               █ ▄▄ █ █ █▄  █▄▄ █▄▄ 
               █▄▄█ ███ █▄▄ ▄▄█ ▄▄█

            █  █ █ █ █▄ ▄█ ██▄ ███ ███
            ██▄█ █ █ █ █ █ █▄█ █▄  █▄ 
            █ ██ ███ █   █ █▄█ █▄▄ █ █
EOF

help (){
cat <<EOF
    Usage: use single letter command to play the game
    h - help, show this command list
    e - do exercise by oneself
    c - change game difficulty level
    q - quit the game
    p - participate competition
    s - show my score in descending order
    l - show my place in all gamers
EOF
}

difLevel(){

cat <<EOF
--- About Difficulty Level ---
Level 1: guess a number between 1 to 100
Level 2: guess a number between 1 to 1000
Level 3: guess a number between 1 to 10000
=== Current Difficulty Level : 1 ===
1) EASY
2) INTERMEDIATE
3) HARD
Select a new difficulty level: 
EOF

read lvl

echo "=== New Difficulty Level : $lvl ===" 
}

game(){
guessNum=10
timesec=$SECONDS

cat <<EOF
    __    __   _                    _                                           
    |_)  |__)  _|   _|  \ /   |    / _   _  |                                    
    | \  \__  (_|  (_|   |    o    \__/ (_) o                                      
=== Current Difficulty Level : $lvl ===  
guess a number between 1 to $((10**lvl*10))
EOF

guessNum=$(($RANDOM % (10**lvl*10)))

while [ "$cont" != "N" ] && [ $cont != "n" ] 
do
duration=$((SECONDS - timesec))
echo -n "your guess: "
read gameInput

if [ $gameInput -gt $guessNum ]
then
echo "too large"
fi

if [ $gameInput -lt $guessNum ]
then 
echo "too small"
fi
if [ $gameInput -eq $guessNum ]
then
((score=lvl*10000/(duration*guessCount)))

cat <<EOF 
Congratulation! You get it!
You used $duration seconds, tried $guessCount times, scored $score
Conitnue Practicing? Enter Y or N:
EOF
read cont
guessNum=$((RANDOM % (10**lvl*10)))
guessCount=1
if [ $cont = 'y' ] | [ $cont = 'Y' ]; then timesec=$SECONDS; fi;
fi

((guessCount++))
done 
}

quit(){
cat <<EOF
Enter your command: q
Are you sure to quit this game?
1) Y
2) N
Make your choice:
EOF
read quitStatus

}

help
while [ $quitStatus != "1" ]
do
read userInput

case $userInput in
    'h')
    help
    ;;

    'c')
    difLevel
    ;;

    'e')
    game
    ;;

    'q')
    quit
    ;;

    'p')
    echo "to do participation competition"
    ;;

    's')
    echo "to do score showing"
    ;;
    
    'l')
    echo "to do place showing"
    ;;

    *)
    echo "Please input a command shown"
    help
    ;;

esac

done