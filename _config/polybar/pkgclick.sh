pac=$(wc -l < /tmp/pkgs 2>/dev/null || printf 0)
aur=$(wc -l < /tmp/aurpkgs 2>/dev/null || printf 0)
if [[ $pac -eq 0 ]] && [[ $aur -eq 0 ]]; then
    notify-send 'no updates'
else
    if [[ $pac -gt 0 ]]; then
        notify-send 'pac updates' "$(cat /tmp/pkgs)"
    fi
    if [[ $aur -gt 0 ]]; then
        notify-send 'aur updates' "$(cat /tmp/aurpkgs)"
    fi
fi
