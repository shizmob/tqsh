#!/usr/bin/env bash

# Terminal escape codes.
C=$(tput clear)
R=$(tput sgr0)
B=$(tput bold)
WHITE=$(tput setaf 7)
GRAY=$(tput setaf 8)

# Settings
TYPEDELAY=0.02

# Engine.
CURRSPRITE=
BASE=$(dirname "$0")

case "$(uname -s)" in 
    Darwin*)
        MUSICCMD=afplay
        ;;
    Linux*)
        MUSICCMD=aplay
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
    read -r -n1
}

function play_core {
    while "$MUSICCMD" "$BASE/assets/$1"; do true; done
}

function play {
    (play_core "$1" 2>/dev/null &)
}

function stop {
    killall "$MUSICCMD" "$BASE/assets/$1"
}

function typewrite {
    msg=$1
    while [[ -n "$msg" ]]; do
        echo -n "${msg:0:1}"
        sleep $TYPEDELAY
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
        "$BASE/bin/$(uname -s)/jp2a" --color --chars="   ...',; clodxkO0KXNWM" --background=dark --height=50 "$BASE/assets/$1.jpg" 2>/dev/null
        echo "----------------------------------------------------------------------------"
    fi
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

function cleanup {
    # Stop lingering music processes.
    echo
    killall "$MUSICCMD" >/dev/null 2>&1

    exit
}
trap 'cleanup' INT TERM EXIT

source ./script.sh
main

echo
killall "$MUSICCMD" >/dev/null 2>&1
