#!/bin/sh

e=$'\e['

# function pc(){
#     if [ "$n" -lt "10" ]; then
#         w=44
#     elif [ "$n" -lt 100 ]; then
#         w=47
#     else
#         w=50
#     fi
#     printf "%-${w}s" "${e}48;05;${n}m|${e}0;38;05;${n}m${n}${e}0;48;05;${n}m|${e}0m "
# }

function pc(){
    printf "${e}"'38;05;'"${n}"'m%-6s' '('"$n"') '
}

for n in {0..7}; do
    pc "$n"
done
printf '\n'

for n in {8..15}; do
    pc "$n"
done
printf '\n'
