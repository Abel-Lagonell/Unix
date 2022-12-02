#!/bin/bash

# Splash Screen
cat <<EOF
               ████ █ █ ███ ███ ███ 
               █ ▄▄ █ █ █▄  █▄▄ █▄▄ 
               █▄▄█ ███ █▄▄ ▄▄█ ▄▄█

            █  █ █ █ █▄ ▄█ ██▄ ███ ███
            ██▄█ █ █ █ █ █ █▄█ █▄  █▄ 
            █ ██ ███ █   █ █▄█ █▄▄ █ █
EOF

# Declare variables
    lvl=1               # Difficulty Level
    gameID=0            # Gamer ID
    regionNum=0         # Region Input
    seasonNum=0         # Season Input
    gameInput=0         # Guesses
    guessCount=1        # Counting the number of guesses
    timesec=1           # Initial Time
    score=0             # Total Score
    nameNum=0           # Check if name is in use
    userInput="z"       # User Input for the game
    cont="Y"            # Continue the game
    quitStatus="2"      # Quit the game (2 -No, 1 - Yes)
    name="A"            # Default name of the Gamer
    season="Spring"     # Default season
    region="SOUTH"      # Default region
    path="./data/regionresults.txt" #default path 
    conti=1;             # Set if to conitnue to the next part
    dis=1;              # Set if wanting to display certain text
    checktop=0          # Variable for check qualification so that playNational can check if they can play in national
    RED="\033[0;31m"    # Red Color
    NC="\033[0m"        # White Color
    regionList=("SOUTH" "NORTHEAST" "MIDWEST" "WEST")
    nat=0               #says whether it was in national league or not
# Loading the Data to the text file (regional results)
loadData(){
    if [ $nat -eq 0 ]; then
        printf "%d,%s,%s,%s,%d,%d,%d,%f\n" $gameID "$name" "$region" "$season" $lvl $guessCount $duration $score >> $path
    else 
        printf "%d,%s,%s,%d,%d,%f\n" $gameID "$name" "$region" $guessCount $duration $score >> $path
    fi
}

# Get the Data of the text file according to the gameID
getData(){  
    name=$(awk -F',' '{if($1=='$gameID') print $2}' $path | tail -n 1)
    region=$(awk -F',' '{if($1=='$gameID') print $3}' $path | tail -n 1)
    season=$(awk -F',' '{if($1=='$gameID') print $4}' $path | tail -n 1)
}

# Default Options for Inputs
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
    r - show regional top three in descending order
    a - check my qualification of attending national arena
    n - show national competitors
    P - participate national competition
    w - print national winners
EOF
}

# Choose the Level
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
EOF

    read -r -p "Select a new difficulty level: " lvl

    echo "=== New Difficulty Level : $lvl ===" 
}

# Actual Game
game(){
    timesec=$SECONDS
    cont="Y"

    cat <<EOF
        __    __   _                    _
        |_)  |__)  _|   _|  \ /   |    / _   _  |
        | \  \__  (_|  (_|   |    o    \__/ (_) o
    === Current Difficulty Level : $lvl ===
    guess a number between 1 to $((10**lvl*10))
EOF

    guessNum=$((RANDOM % (10**lvl*10) ))

    while [ $cont != "N" ] && [ $cont != "n" ] 
    do
        duration=$((SECONDS - timesec))
        read -r -p "your guess: " gameInput

        if [ $gameInput -gt $guessNum ]; then
            echo "too large"
        elif [ $gameInput -lt $guessNum ]; then 
            echo "too small"
        elif [ $gameInput -eq $guessNum ]; then
            ((score=lvl*10000/(duration*guessCount) ))

            cat <<EOF 
            Congratulation! You get it!
            You used $duration seconds, tried $guessCount times, scored $score
EOF
            if [ $nat -eq 0 ]; then 
                read -r -p "Conitnue Practicing? Enter Y or N: " cont
            else 
                cont="N"
            fi
            guessNum=$((RANDOM % (10**lvl*10) ))
            guessCount=1
            if [[ "$cont" = "y" || "$cont" = "Y" ]]; then timesec=$SECONDS; fi;
            if [ ! $gameID -eq 0 ]; then loadData; fi            
        fi
        ((guessCount++))
    done 
}

# Quiting the game
quit(){
    cat <<EOF
    Enter your command: q
    Are you sure to quit this game?
    1) Y
    2) N
EOF
    read -r -p "Make your choice: " quitStatus
    while [[ ! $quitStatus =~ ^[1-2] ]]; do
    read -r -p "Please input 1 or 2: " quitStatus
    done 
}

# Check to see if the files are already loaded
dataLoad(){
    echo "loading data and initialize data structures"

    if [ ! -d ./data ]; then
        echo "./data folder not exist, creating it..."
        mkdir ./data
        echo "./data folder created"
    fi

    if [ ! -f ./data/regionresults.txt ]; then
        echo "./data/regionresults.txt not exist, creating it..."
        touch ./data/regionresults.txt
        echo "./data/regionresults.txt created"
    fi

    if [ ! -f ./data/nationresults.txt ]; then
        echo "./data/nationresults.txt not exist, creating it..."
        touch ./data/nationresults.txt
        echo "./data/nationresults.txt created"
    fi

}

# Gamer name
nameSelect(){
    read -r -p "Please enter your name: " name
    while [[ ( ! $name =~ ^[a-zA-Z]) || ( $name =~ \ ) || ( $name =~ [0-9] ) ]]; do
        echo "Your name can contain only letters!"
        read -r -p "Please enter your name: " name
    done 
}

# Gamer region 
regionSelect(){
    cat <<EOF 
    Available regions for Competition: 
    1) SOUTH
    2) NORTHEAST
    3) MIDWEST
    4) WEST
EOF
    read -r -p "Please Select a region: " regionNum
    while [[ ! $regionNum =~ ^[1-4] ]]; do
        echo "You didn't make your choice!"
        read -r -p "Please Select a region: " regionNum
    done

    case $regionNum in
        1) region="SOUTH" ;;
        2) region="NORTHWEST" ;;
        3) region="MIDWEST" ;;
        4) region="WEST" ;;
    esac

    if [ $conti -eq 1 ]; then seasonSelect; else conti=1; fi
}

# Gamer Season
seasonSelect(){
    cat <<EOF
    Seasons for regional competition:
    1) Spring
    2) Summer
    3) Fall
EOF
    read -r -p "Please select a season: " seasonNum
    while [[ ! $seasonNum =~ ^[1-3] ]]; do
       echo "You didn't make a choice!"
       read -r -p "Please select a season: " seasonNum
    done

    case $seasonNum in
        1) season="Spring" ;;
        2) season="Summer" ;;
        3) season="Fall" ;;
    esac

    if [ $nameNum -eq 0 ]; then
    nameSelect
    fi

}

# Gamer ID 
getGameID(){
    read -r -p "Please Enter your UNIQUE 9 digit gamer ID: " gameID

    while [[ ! $gameID =~ ^[0-9]{9} ]]; do
        echo "Your Gamer ID $gameID is not 9 digits!"
        read -r -p "Please Enter your UNIQUE 9 digit gamer ID: " gameID
    done 
}

# Check If Gamer ID exists
participation(){
    echo "Welcome to the national game of guessing numbers!"
    getGameID
    
    if [[ $(grep -c "$gameID" ./data/regionresults.txt) -eq 0 ]]; then nameNum=0; regionSelect;
    else 
        getData
        echo "Hello $name, Welcome Back!"
        var=$(grep -c "$gameID" data/regionresults.txt) 
        echo -n "You have competed $var times in the regional arenas, "
        if [[ $var -lt 3 ]]; then echo "You still can compete $((3 - var)) times in the regional arenas."; nameNum=1; regionSelect;
        else echo "please participate the national arena if you are qualified."      
        fi 
    fi
}

# Showing data of /regionresults.txt about the GamerID
showData(){
    if [ $gameID -eq 0 ]; then getGameID; fi
    var=$(grep -c "$gameID" data/regionresults.txt) 
    if [[ var -eq 0 ]]; then
        cat <<EOF
    You did NOT participate any regional arenas yet.
    Please participate regional arenas first.
                Good luck!
EOF
    else 
        getData
        if [ $dis -eq 1 ]; then echo "Hello $name, here are your Competitions"; else dis=1; fi
        cat <<EOF
-------------------------------------------------
Region     Season   Level    Times Seconds  Score
-------------------------------------------------
EOF
        awk -F',' '{if($1=='$gameID') printf("%-10s %-8s %-8d %-5d %-7d %6.2f\n", $3, $4, $5, $6, $7, $8)}' ./data/regionresults.txt | sort -rk 6
        echo "-------------------------------------------------"
    fi
}

# Showing all of th data of /regionresults.txt highlighting the Gamer 
whichPlace(){
    getGameID
    var=$(grep -c "$gameID" data/regionresults.txt) 
    if [[ $var -eq 0 ]]; then
        cat <<EOF
    You did NOT participate any regional arenas yet.
    Please participate regional arenas first.
                Good luck!
EOF
    else 
    getData
    echo -e "   ===== ${RED} regional competition results ${NC}======"

    cat <<EOF
----------------------------------------------------------------------------
ID        Name             Region     Season   Level    Times Seconds  Score
----------------------------------------------------------------------------
EOF
    
    sort -t, -nrk8 ./data/regionresults.txt | awk -F',' '{
        if($1=='$gameID') 
            printf("'$RED'%s %-16s %-10s %-8s %-8d %-5d %-7d %6.2f\n",$1, $2, $3, $4, $5, $6, $7, $8); 
        else 
            printf("'$NC'%s %-16s %-10s %-8s %-8d %-5d %-7d %6.2f\n",$1, $2, $3, $4, $5, $6, $7, $8)
    }';

    echo -e "${NC}\c----------------------------------------------------------------------------\n\n"
    fi
}

#prints regional results for the region
regionalResults(){
    conti=0
    if [ $dis -eq 1 ]; then regionSelect; else dis=1; fi
    echo -e "\t\t===== ${RED} The Top 3 results of region $region ${NC}======"
    cat <<EOF
----------------------------------------------------------------------------
ID        Name             Region     Season   Level    Times Seconds  Score
----------------------------------------------------------------------------
EOF
    grep "\<$region\>" ./data/regionresults.txt | sort -t ',' -rn -k 8,8 | awk -F, '!a[$1]++' |  head -n 3  | awk -F',' '{
        printf("%s %-16s %-10s %-8s %-8d %-5d %-7d '$RED'%6.2f\n'$NC'",$1, $2, $3, $4, $5, $6, $7, $8)
    }';
    echo -e "----------------------------------------------------------------------------\n\n"
}

#Check if the player is qualified for nationals
checkQualifcation(){
    dis=0
    if [ $gameID -eq 0 ]; then getGameID; fi
    getData
    var=$(grep "$gameID" data/regionresults.txt | awk -F, '!a[$3]++' | wc -l)
    if [ $var -gt 1 ]; then 
        echo "Dear $name, You competed in $var regions so you are DISQUALIFIED!"
        echo "Below are your records:"
        showData
    elif [ $var -eq 0 ] ; then 
        cat <<EOF
    You did NOT participate any regional arenas yet.
    Please participate regional arenas first.
                Good luck!
EOF
    elif [[ $var -eq 1 && $conti -eq 1 ]]; then
        cat<< EOF
    Congratulations! $name, you are qualified to attend the national arena
EOF

    echo -e "\t\t=====${RED} The Top 3 results of region $region ${NC}======"
        cat<<EOF
----------------------------------------------------------------------------
ID        Name             Region     Season   Level    Times Seconds  Score
----------------------------------------------------------------------------
EOF
    grep "\<$region\>" ./data/regionresults.txt | sort  -t ',' -rn -k 8,8 | awk -F, '!a[$1]++' | head -n 3  | awk -F',' '{
        if($1=='$gameID') 
            printf("'$RED'%s %-16s %-10s %-8s %-8d %-5d %-7d %6.2f\n",$1, $2, $3, $4, $5, $6, $7, $8); 
        else 
            printf("'$NC'%s %-16s %-10s %-8s %-8d %-5d %-7d %6.2f\n",$1, $2, $3, $4, $5, $6, $7, $8)
    }'; 
    echo -e "----------------------------------------------------------------------------\n\n"
    else 
        checktop=1; conti=1
    fi
}

#print all the regional results
nationalRegionalResults(){
    for t in "${regionList[@]}"; do
        dis=0
        region=$t
        regionalResults
        echo ""
    done
}

playNational(){
    getGameID
    getData
    conti=0
    nat=1
    checkQualifcation
    if [ $checktop -eq 1 ]; then
        var=$(grep "\<$region\>" $path  | sort  -t ',' -rn -k 8,8 | awk -F, '!a[$1]++' | head -n 3 | grep -c "\<$gameID\>")
        path="./data/nationresults.txt"
        var2=$(grep -c "\<$gameID\>" $path)
        if [ $var -eq 0 ]; then 
            echo "Hello $name, you are not in the top 3 of the $region arena!"
        elif [ $var2 -gt 0 ]; then
            echo "Hello $name, you can play only ONCE in the national arena!"
        else
            echo "Hello $name, Welcome to the National arena of guessing numbers!"
            lvl=3
            game
        fi
    fi
    path="./data/regionresults.txt"
    nat=0
}

winner(){
    echo -e "***************${RED}NATIONAL WINNERS${NC}***************"
    cat<<EOF
Name       Region        Score Medal 
EOF
    sort ./data/nationresults.txt -t ',' -rn -k 6,6 | head -n 6 | awk -F',' -v red="$RED" -v white="$NC" '
    BEGIN{medals="Gold,Silver,Silver,Bronze,Bronze,Bronze"; split(medals,medal,",");} 
    {
        if(NR % 2)
            printf("%s%-10s %-10s %8.2f %-8s%s\n", red, $2, $3, $6, medal[NR],white );
        else
            printf("%-10s %-10s %8.2f %-8s\n", $2, $3, $6, medal[NR] );
    }';
    echo -e "**********************************************"
}

# Running of the core
dataLoad
help
while [ "$quitStatus" != "1" ]; do
    read -r -p "Please Input a command: " userInput
    case $userInput in
        "h") help ;;
        "c") difLevel ;;
        "e") game ;;
        "q") quit ;;
        "p") participation ;;
        "s") gameID=0; showData ;;
        "l") whichPlace ;;
        "r") regionalResults ;; 
        "a") gameID=0; checkQualifcation ;;
        "n") nationalRegionalResults;;
        "P") playNational;;
        "w") winner;;
        *) echo "Please input a command shown"; help ;;
    esac

done

