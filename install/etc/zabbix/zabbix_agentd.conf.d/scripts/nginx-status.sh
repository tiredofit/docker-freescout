#!/bin/bash
HOST="localhost"
PORT="73"
 
function proc_num {
    num=$(pgrep nginx |wc -l)
}
function active {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |grep 'Active' |awk '{print $NF}')
}
function reading {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |grep 'Reading' |awk '{print $2}')
}
function writing {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |grep 'Writing' |awk '{print $4}')
}
function waiting {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |grep 'Waiting' |awk '{print $6}')
}
function accepts {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |awk NR==3 |awk '{print $1}')
}
function handled {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |awk NR==3 |awk '{print $2}')
}
function requests {
    num=$(curl -s "http://$HOST:$PORT/stub_status" |awk NR==3 |awk '{print $3}')
}

$1
echo ${num:-0}

