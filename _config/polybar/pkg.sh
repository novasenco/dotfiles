#!/usr/bin/env bash

checkupdates 2>/dev/null >/tmp/pkgs
pac="$(wc -l < /tmp/pkgs)"

# add patterns to ~/.cowerignore to ignore files below
cower -u 2>/dev/null | grep -Ev $(cat $HOME/.cowerignore 2>/dev/null || printf '_') | sed '/^$/d' >/tmp/cowerpkgs
aur=$(wc -l < /tmp/cowerpkgs)

[[ $(($pac + $aur)) -gt 0 ]] && printf " "
[[ $pac -gt 0 ]] && printf "${pac}"
[[ $pac -gt 0 ]] && [[ $aur -gt 0 ]] && printf " + "
[[ $aur -gt 0 ]] && printf "${aur}"
[[ $pac -eq 0 ]] && [[ $aur -gt 0 ]] && printf " (aur)"
[[ $pac -eq 0 ]] && [[ $aur -eq 0 ]] && printf ""
printf "\n"
