t=0

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        date +'%d %b  %H:%M'
    else
        date -u +'%d %b  %H:%M utc'
    fi
    sleep 10 &
    wait
done
