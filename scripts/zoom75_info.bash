#!/usr/bin/env bash

keybinds_info="
<b>Wireless operation</b>
Switch to bluetooth mode (1)  FN + Z
Switch to bluetooth mode (2)  FN + X
Switch to bluetooth mode (3)  FN + C
Switch to wireless mode  FN + V
Switch to wired (USB) mode  FN + Space

<b>Sleep time</b> (while plugging usb)
Change to 10 min  Space + Z
Change to 60 min  Space + X

<b>Lighting control</b>
Increase LED brightness  FN + Up
Decrease LED brightness  FN + Down
Slower LED effects  FN + Left
Faster LED effects  FN + Right
Toggle LED  FN + \\\|
Switch lighting effects  FN + ]}
Increase hue  FN + P
Decrease hue  FN + ;:
Increase saturation  FN + [{
Decrease saturation  FN + '\"
Lighting test (mode flash 5 times)  FN + /? (short)
Lighting test (test mode)  FN + /? (long)

<b>LCD screen control</b>
Toggle LCD on/off  FN + Delete
Turn LCD on/off  FN + RShift + Delete
LCD page up  FN + PageUp
LCD page down  FN + PageDown

<b>Miscellaneous</b>
Charge light indicator  Space + M (while plugging usb)
Factory settings  Space + backspace (while plugging usb)
Restart reset  FN + RShift + R
Deep sleep  FN + CAPS (long press - 3s)

<b>Key codes</b> (while plugging usb)
6-key / N-key rollover  Space + N
Swap LCtrl / Caps keys  Space + LCtrl
Unswap LCtrl / Caps keys  Space + Caps
Disable LGui  Space + LGui
Swap Grave / Escape (macOs) keys  Space + Grave
Swap Backspace / \" \\\ \" keys  Space + \\\|
"

zenity --info --no-wrap --title="Zoom75 Operation Instructions" --text="${keybinds_info}"