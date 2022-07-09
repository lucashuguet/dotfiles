#!/usr/bin/env python3

from libqtile.command.client import InteractiveCommandClient

c = InteractiveCommandClient()

sticky_windows = ["mpv", "Picture-in-Picture"]
windows = []

for window in c.windows():
    if window["floating"] and not window["fullscreen"]:
        for sticky_window in sticky_windows:
            if sticky_window in window["name"]:
                windows.append(window)

for window in windows:
    c.window[window["id"]].togroup()
    c.window[window["id"]].bring_to_front()


for cwindow in c.group.info()["windows"]:
    for window in c.windows():
        if not window["floating"] and not window["fullscreen"]:
            if window["name"] == cwindow:
                print(window)
                c.window[window["id"]].focus()
