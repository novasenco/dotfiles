#!/bin/bash

l="$(xsel --clipboard --output)"
# notify-send "co: $l"

if ! [[ "$l" =~ ^http ]]; then
    >&2 echo ""$l" not url"
    exit 1
fi

file_num='0'
while :; do
    [[ -e "/tmp/clip_open${file_num}" ]] || break
    (( file_num ++ ))
done

[[ "$l" =~ pastebin.com[^$]+ ]] && l="$(printf "$l" | perl -pe 's/(?!\.com\/raw\/)\.com\//\.com\/raw\//g')"
[[ "$l" =~ dpaste.com[^$]+ ]] && l="$(printf "$l" | perl -pe 's/(^[^#]+)#.+$/${1}.txt/gm')"

if type elinks >/dev/null 2>&1; then
    dumper='elinks'
elif type lynx >/dev/null 2>&1; then
    dumper='lynx'
else
    dumper=''
fi

if [[ $1 == force-file ]]; then
    ft="vim (editor)"
elif [[ "$1" == 'force-img' ]]; then
    ft='feh (image)'
elif [[ "$1" == 'force-gif' ]]; then
    ft='gifview (gif)'
elif [[ "$1" == 'force-video' ]]; then
    ft='mpv (video)'
elif [[ "$1" == 'force-audio' ]]; then
    ft='mpv (audio)'
elif [[ "$1" == 'force-browser' ]]; then
    ft="${BROWSER:-firefox} (browser)"
elif [[ "$1" == 'force-pdf' ]]; then
    ft='zathura (pdf)'
elif [[ "$l" =~ (.png$|.jpg$|.jpeg$) ]]; then
    ft='feh (image)'
elif [[ "$l" =~ (.gif$|.gifv$) ]]; then
    ft='gifview (gif)'
elif [[ "$l" =~ (.pdf) ]]; then
	ft='zathura (pdf)'
elif [[ "$l" =~ https?://(www\.)?youtube ]]; then
    ft='mpv (video)'
elif [[ "$l" =~ (\/raw\/|.txt$|.diff$) ]]; then
    ft="vim (editor)"
elif [[ "$l" =~ soundcloud ]]; then
    ft='mpv (audio)'
else
    if type rofi >/dev/null 2>&1; then
        ft=$(printf "${dumper:+vim (dump using ${dumper})\n}"${BROWSER:-firefox}" (browser)\nvim (editor)\nfeh (image)\ngifview (gif)\nmpv (video)\nmpv (audio)\nzathura (pdf)" | rofi -dmenu -p "open <<"${l}">> using: ") || exit 1
    elif type rofi >/dev/null 2>&1; then
        ft=$(printf "${dumper:+vim (dump using "${dumper}")\n}"${BROWSER:-firefox}" (browser)\nvim (editor)\nfeh (image)\ngifview (gif)\nmpv (video)\nmpv (audio)\nzathura (pdf)" | dmenu -l 20 -p "open <<"${l}">> using: ") || exit 1
    else
        if [[ -n $dumper ]]; then
            notify-send "dumping to vim with ${dumper}"
            printf "dumping to vim with ${dumper}"
            ft="vim (dump using ${dumper})"
        else
            notify-send "opening in vim"
            printf "opening in vim"
            ft="vim (editor)"
        fi
    fi
fi

case "$ft" in
    "vim (editor)")
        # xterm -e "vim <(curl $l)"
        curl $l > /tmp/clip_open${file_num}
        ${TERMINAL:xterm} -e vim /tmp/clip_open${file_num} +1; rm "/tmp/clip_open${file_num}"
        ;;
    "vim (dump using ${dumper})")
        elinks --dump "$l" >> "/tmp/clip_open${file_num}"
        ${TERMINAL:xterm} -e vim /tmp/clip_open${file_num} +1; rm "/tmp/clip_open${file_num}"
        ;;
    'feh (image)')
        ((curl "$l" > /tmp/clip_open${file_num}; feh /tmp/clip_open${file_num}) &)
        # (feh "$l" &)
        ;;
    'zathura (pdf)')
        ((curl "$l" > /tmp/clip_open${file_num}; zathura /tmp/clip_open${file_num}) &)
        ;;
    'gifview (gif)')
        curl "$l" | gifview -a
        ;;
    'mpv (video)')
        mpv "$l"
        ;;
    'mpv (audio)')
        st -e mpv "$l"
        ;;
    "${BROWSER:-firefox} (browser)")
        ("$BROWSER" "$l" &)
        ;;
esac

sleep .5
printf "$l" | xsel --clipboard --input
