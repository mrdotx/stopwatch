#!/usr/bin/env bash

# path:       ~/repos/stopwatch/stopwatch.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/stopwatch
# date:       2020-02-28T08:29:12+0100

script=$(basename "$0")
help="$script [-h/--help] -- script to measure the time
  Usage:
    $script [-d]

  Settings:
    [-d] = disable header

  Keys:
    Start/Stop: space
    Quit:       q

  Examples:
    $script
    $script -d"

header=" Start/Stop: space
 Quit:       q
 "

t_stop=0
t_now=0
t_idx=0
stat=2
n=1

set_t_now(){
    t_now=$(date +%s%3N)
}

t_date() {
    t="$1"
    s=$(printf "%1d\n" "${t: 0 : -3}")
    ms=${t: -3 : 3 }
    printf "\r%s" "   $n) $(TZ=UTC date -d"@$s.$ms" +%H:%M:%S.%3N)"
}

run(){
    t_stop=$((t_now-t_idx))
    t_date $t_stop
}

reset(){
    set_t_now
    t_idx=$t_now
}

read_key(){
    last=$1
    read -rsN1 -t.1 key;
    case "$stat" in
        1) [ "$key" = $'\x20' ] && printf "\n" && n=$((n+1)) && return 2 ;;
        2) [ "$key" = $'\x20' ] && return 1 ;;
    esac
    return "$last";
}

stopwatch(){
    while [ ! "$key" = "q" ]
    do
        set_t_now
        case "$stat" in
            1) run ;;
            2) reset ;;
        esac
        read_key $stat
        stat=$?
        sleep .1
    done
}

case "$1" in
    -h|--help)
        printf "%s\n" "$help"
        exit0
        ;;
    -d)
        clear
        stopwatch
        ;;
    *)
        clear
        printf "%s\n" "$header"
        stopwatch
        ;;
esac
