#!/bin/bash

lvl=1
userInput='z'
gameInput=0
cont="Y"
guessCount=1
timesec=1
score=0
quitStatus="2"
gameID=0
regionNum=0
seasonNum=0
name='A'
season='Spring'
region='SOUTH'

loadData(){
    printf "%d, %s, %s, %s, %d, %d, %d, %f" $gameID "$name" "$region" "$season" $lvl $guessCount $duration $score >> ./data/regionresults.txt
}

getData(){  
    name=$(awk -F',' '{if($1=='$gameID') print $2}' ./data/regionresults.txt | tail -n 1)
    region=$(awk -F',' '{if($1=='$gameID') print $3}' ./data/regionresults.txt | tail -n 1)
    season=$(awk -F',' '{if($1=='$gameID') print $4}' ./data/regionresults.txt | tail -n 1)

}

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
    cont='Y'

    cat <<EOF
        __    __   _                    _
        |_)  |__)  _|   _|  \ /   |    / _   _  |
        | \  \__  (_|  (_|   |    o    \__/ (_) o
    === Current Difficulty Level : $lvl ===
    guess a number between 1 to $((10**lvl*10))
EOF

    guessNum=$((RANDOM % (10**lvl*10)))

    while [ $cont != "N" ] && [ $cont != "n" ] 
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
            ((score=lvl*10000/(duration*guessCount) ))

            cat <<EOF 
            Congratulation! You get it!
            You used $duration seconds, tried $guessCount times, scored $score
            Conitnue Practicing? Enter Y or N:
EOF
            read cont
            guessNum=$((RANDOM % (10**lvl*10) ))
            guessCount=1
            if [ $cont = 'y' ] | [ $cont = 'Y' ]; then timesec=$SECONDS; fi;
            if [ ! $gameID -eq 0 ]; then loadData; fi
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

dataLoad(){
    echo "loading data and initialize data structures"

    if [ ! -d ./data ];
    then
        echo "./data folder not exist, creating it..."
        mkdir ./data
        echo "./data folder created"
    fi

    if [ ! -f ./data/regionresults.txt ];
    then
        echo "./data/regionresults.txt not exist, creating it..."
        touch ./data/regionresults.txt
        echo "./data/regionresults.txt created"
    fi

    if [ ! -f ./data/nationresults.txt ];
    then
        echo "./data/nationresults.txt not exist, creating it..."
        touch ./data/nationresults.txt
        echo "./data/nationresults.txt created"
    fi

}

nameSelect(){
    read -p "Please enter your name: " name
    while [[ ! $name =~ ^[a-zA-Z] ]]; do
        echo "Your name can contain only letters!"
        read -p "Please enter your name: " name
    done 
}

regionSelect(){
    cat <<EOF 
    Available regions for Competition: 
    1) SOUTH
    2) NORTHEAST
    3) MIDWEST
    4) WEST
EOF
    read -p "Please Select a region: " regionNum
    while [[ ! $regionNum =~ ^[0-4] ]]; do
        echo "You didn't make your choice!"
        read -p "Please Select a region: " regionNum
    done

    case $regionNum in
        1) region='SOUTH' ;;
        2) region='NORTHWEST' ;;
        3) region='MIDWEST' ;;
        4) region='WEST' ;;
    esac

    seasonSelect
}

seasonSelect(){
    cat <<EOF
    Seasons for regional competition:
    1) Spring
    2) Summer
    3) Fall
    Please select a season:
EOF
    read seasonNum
    while [[ ! $seasonNum =~ ^[1-3] ]]; do
       echo "You didn't make a choice!"
       read -p "Please select a season" seasonNum
    done

    case $seasonNum in
        1) season='Spring' ;;
        2) season='Summer' ;;
        3) season='Fall' ;;
    esac

    nameSelect
}

getGameID(){
    read -p 'Please Enter your UNIQUE 9 digit gamer ID: ' gameID

    while [[ ! $gameID =~ ^[0-9]{9} ]]; do
        echo "Your Gamer ID $gameID is not 9 digits!"
        read -p 'Please Enter your UNIQUE 9 digit gamer ID: ' gameID
    done 
}

participation(){
    echo "Welcome to the national game of guessing numbers!"
    getGameID
    
    if [[ $(grep $gameID ./data/regionresults.txt) -eq 0 ]]
    then regionSelect; 
    else 
        getData
        echo "Hello $name, Welcome Back!"
        var=$(grep -c $gameID data/regionresults.txt) 
        echo "You have competed $var times in the regional arenas, please participate the national arena if you are qualified."        
    fi
}

showData(){
    getGameID
    var=$(grep -c $gameID data/regionresults.txt) 
    if [[ var -eq 0 ]]; then
        cat <<EOF
    You did NOT participate any regional arenas yet.
    Please participate regional arenas first.
                Good luck!
EOF
    else 
        getData
        echo "Hello $name, here are your Competitions"
        cat <<EOF
-------------------------------------------------
Region     Season   Level    Times Seconds  Score
-------------------------------------------------
EOF
        awk -F',' '{if($1=='$gameID') printf("%-10s %-8s %-8d %-5d %-7d %6.2f\n", $3, $4, $5, $6, $7, $8)}' ./data/regionresults.txt | sort -rk 6
        echo "-------------------------------------------------"
    fi
}

whichPlace(){
    getGameID
    var=$(grep -c $gameID data/regionresults.txt) 
    if [[ var -eq 0 ]]; then
        cat <<EOF
    You did NOT participate any regional arenas yet.
    Please participate regional arenas first.
                Good luck!
EOF
    else 
    getData
    RED='\033[0;31m'
    NC='\033[0m'

    echo -e "===== ${RED} regional competition results ${NC}======"

    cat <<EOF
----------------------------------------------------------------------------
ID        Name             Region     Season   Level    Times Seconds  Score
----------------------------------------------------------------------------
EOF
    
    sort -t, -nrk8 ./data/regionresults.txt | awk -F',' '{if($1=='$gameID') printf("'$RED'%s %-16s %-10s %-8s %-8d %-5d %-7d %6.2f\n",$1, $2, $3, $4, $5, $6, $7, $8); else printf("'$NC'%s %-16s %-10s %-8s %-8d %-5d %-7d %6.2f\n",$1, $2, $3, $4, $5, $6, $7, $8)}';

    echo -e "${NC}\c"
    fi
}

# Running of the core
dataLoad
help
while [ $quitStatus != "1" ]; do
    read userInput
    case $userInput in
        'h') help ;;
        'c') difLevel ;;
        'e') game ;;
        'q') quit ;;
        'p') participation ;;
        's') showData ;;
        'l') whichPlace ;;
        *) echo "Please input a command shown"; help ;;
    esac

done

