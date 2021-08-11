#!/bin/sh

xset r rate 350 40
# xset r off
xset m 5/1 10

# if pgrep xcape >/dev/null; then
#     pkill xcape
# fi

# xmodmap -e 'keycode 9 = Escape Caps_Lock'

setxkbmap -layout us,dvorak \
  -model asus_laptop \
  -option \
  -option esperanto:qwerty \
  -option compose:menu,lv3:ralt_switch,grp:shifts_toggle \
  \
  || exit

# TODO: find touchpad name on new system
id="$(xinput --list --id-only 'ELAN1200:00 04F3:30BA Touchpad')"

xinput set-prop $id 'libinput Disable While Typing Enabled' 0
xinput set-prop $id 'libinput Horizontal Scroll Enabled' 1
xinput set-prop $id 'libinput Tapping Enabled' 0
xinput set-prop $id 'libinput Accel Speed' '0.4'

# https://shallowsky.com/blog/tags/xmodmap/
xmodmap -e "keysym F1 = Pointer_Button1 Pointer_Button1 Pointer_Button1 Pointer_Button1"
xmodmap -e "keysym F2 = Pointer_Button2 Pointer_Button2 Pointer_Button2 Pointer_Button2"
xmodmap -e "keysym F3 = Pointer_Button3 Pointer_Button3 Pointer_Button3 Pointer_Button3"
xkbset m
xkbset exp '=m'

# Tab = Escape
xmodmap -e 'keycode 23 = Escape NoSymbol Escape'
# Escape = grave
xmodmap -e 'keycode 9 = grave asciitilde grave asciitilde dead_grave dead_tilde dead_grave'
# grave = Tab
xmodmap -e 'keycode 49 = Tab ISO_Left_Tab Tab ISO_Left_Tab'
# Control_L = Tab
xmodmap -e 'keycode 37= Tab ISO_Left_Tab Tab ISO_Left_Tab'
