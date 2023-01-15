#!/usr/bin/env bash

checkupdates 2>/dev/null | sed 's/ .*//' >/tmp/pkgs
pac="$(wc -l < /tmp/pkgs)"

paru -Qqua >/tmp/aurpkgs
aur=$(wc -l < /tmp/aurpkgs)

[[ $(($pac + $aur)) -gt 0 ]] && printf " "
[[ $pac -gt 0 ]] && printf "${pac}"
[[ $pac -gt 0 ]] && [[ $aur -gt 0 ]] && printf " + "
[[ $aur -gt 0 ]] && printf "${aur}"
[[ $pac -eq 0 ]] && [[ $aur -gt 0 ]] && printf " (aur)"
[[ $pac -eq 0 ]] && [[ $aur -eq 0 ]] && printf ""
printf "\n"
