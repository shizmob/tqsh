#!/usr/bin/env bash

# Terminal escape codes.
C=$(tput clear)
R=$(tput sgr0)
B=$(tput bold)
WHITE=$(tput setaf 7)
GRAY=$(tput setaf 8)

# Settings
TYPESPEED=0.02

# Engine.
CURRSPRITE=
BASE=$(dirname "$0")

case "$(uname -s)" in 
    Darwin*)
        PLAYMUSIC=afplay
        ;;
    Linux*)
        PLAYMUSIC=aplay
        ;;
esac

function clear {
    echo -n "$C"
}

function gencolor {
    sum=0
    char=$1
    while [[ -n "$char" ]]; do
        sum=$(((sum + ${char:0:1}) % 6))
        char=${char:1}
    done
    echo $(tput setaf $((sum + 1)))
}

function pause {
    read -n1 -r
}

function play_core {
    while true; do
        if ! "$PLAYMUSIC" "$BASE/assets/$1"; then break; fi
    done
}

function play {
    play_core "$1" &
}

function typewrite {
    msg=$1
    while [[ -n "$msg" ]]; do
        echo -n "${msg:0:1}"
        sleep $TYPESPEED
        msg=${msg:1}
    done
}

function think {
    show $CURRSPRITE
    echo -n "  $WHITE"
    typewrite "$1"
    pause
}

function say {
    show $CURRSPRITE
    echo -n "  $WHITE$B"
    echo -n $(gencolor "$1")
    echo -n "$1$R: "
    typewrite "$2"
    pause
}

function show {
    CURRSPRITE=$1
    echo -n "$C"
    if [[ ! -z $CURRSPRITE ]]; then
        ./bin/$(uname -s)-jp2a --color --chars="   ...',; clodxkO0KXNWM" --background=dark --height=50 "$BASE/assets/$1.jpg" 2>/dev/null
        echo "----------------------------------------------------------------------------"
    fi
}

function cmd {
    echo
    echo "$GRAY$1"
    echo
}

function choice {
    show $CURRSPRITE
    i=1

    echo "$WHITE"
    typewrite "$1"
    echo

    shift
    while [[ $# -gt 1 ]]; do
        choices[$i]=$2

        echo -n $(gencolor "$i")
        echo "$i. $1"
        i=$((i + 1))
        shift 2
    done

    while true; do
        read -r -n1 -p "             $WHITE Choice: [1..$((i - 1))]: " choice
        if [[ ! -z "${choices[$choice]}" ]]; then
            break
        fi
        echo "Invalid choice."
    done

    func="${choices[$choice]}"
    eval $func
} 

source ./script.sh
main

echo
killall "$PLAYMUSIC" 2>/dev/null
