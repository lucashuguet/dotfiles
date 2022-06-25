#!/usr/bin/env python3
# code from https://github.com/qtile/qtile/issues/1260

from libqtile.command import lazy
from libqtile.command.client import InteractiveCommandClient

c = InteractiveCommandClient()
floating_mpvs = [(w['id'], w['name'], w['group']) for w in c.windows()
                     if 'mpv' in w['name'] and w['floating'] and not w['fullscreen']]
if len(floating_mpvs) == 0:
    exit
for floating_mpv in floating_mpvs:
    c.window[floating_mpv[0]].bring_to_front()
    c.window[floating_mpv[0]].togroup()
