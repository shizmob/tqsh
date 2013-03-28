#!/usr/bin/env bash

# Terminal escape codes.
CLEAR=$(tput clear)
RESET=$(tput sgr0)
BOLD=$(tput bold)
WHITE=$(tput setaf 7)
GRAY=$(tput setaf 8)

# Settings
TYPEDELAY=0.02

# Engine.
CURRSPRITE=
BASE=$(dirname "$0")
ORIG_SSTY=$(stty -g)

stty -echo

case "$(uname -s)" in 
    Darwin*)
        MUSICCMD=afplay
        ;;
    Linux*)
        MUSICCMD=aplay
        ;;
esac

function clear {
    echo -n "$CLEAR"
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
    echo -n "  $WHITE$BOLD"
    echo -n $(gencolor "$1")
    echo -n "$1$RESET: "
    typewrite "$2"
    pause
}

function show {
    CURRSPRITE=$1
    echo -n "$CLEAR"
    if [[ ! -z $CURRSPRITE ]]; then
        "$BASE/bin/$(uname -s)/jp2a" --color --chars="   ...',; clodxkO0KXNWM" --background=dark --height=50 "$BASE/assets/$1.jpg" 2>/dev/null
        echo "----------------------------------------------------------------------------"
    fi
}

function choice {
    show $CURRSPRITE
    i=1

    echo "$WHITE"
    echo -n "  "
    typewrite "$1"
    echo

    shift
    while [[ $# -gt 1 ]]; do
        choices[$i]=$2

        echo -n $(gencolor "$2")
        echo -n "    $i. "
        typewrite "$1"
        echo
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

    eval ${choices[$choice]}
} 

function cleanup {
    # Stop lingering music processes.
    killall "$MUSICCMD" >/dev/null 2>&1

    stty $(ORIG_STTY)
    clear
    exit
}
trap 'cleanup' INT TERM EXIT

source ./script.sh
main
