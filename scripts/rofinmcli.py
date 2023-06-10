#!/usr/bin/env python3

import subprocess

subprocess.run(["notify-send", "rofinmcli.py", "Starting networks scan"])

knowned = subprocess.check_output(["nmcli", "-f", "NAME", "c"]).decode("utf-8")
lines = knowned.strip().split("\n")[1:]
knowned_net = []

for line in lines:
    knowned_net.append(line.strip())

subprocess.run(["nmcli", "d", "wifi", "rescan"])
output = subprocess.check_output(["nmcli", "-f", "SSID,IN-USE", "d", "wifi", "list"]).decode("utf-8")

lines = output.strip().split("\n")[1:]
ssids = []

for line in lines:
    fields = line.strip().split()

    in_use = "*" in fields[-1]

    if len(fields) > 1:
        if in_use:
            ssid = " ".join(fields[:-1])
        else:
            ssid = " ".join(fields)
    else:
        ssid = fields[0]


    if in_use:
        ssid += " (connected)"

    ssids.append(ssid)

inputs = "\n".join(ssids)

selected = subprocess.check_output(["rofi", "-dmenu"], text=True, input=inputs).strip()

if not "connected" in selected:
    if selected in knowned_net:
        process = subprocess.run(["nmcli", "d", "wifi", "connect", selected], capture_output=True)
        print(process.returncode)
        if process.returncode == 0:
            subprocess.run(["notify-send", "rofinmcli.py", "Succesfully connected to " + selected])
        if process.returncode == 4:
            subprocess.run(["alacritty", "--class", "nmcli", "-e", "nmcli", "--ask", "d", "wifi", "connect", selected])
    else:
        subprocess.run(["alacritty", "--class", "nmcli", "-e", "nmcli", "--ask", "d", "wifi", "connect", selected])

else:
    selected = selected.replace(" (connected)", "")
    process = subprocess.run(["nmcli", "c", "down", selected])
    if process.returncode == 0:
        subprocess.run(["notify-send", "rofinmcli.py", "Succesfully disconnected from " + selected])
    if process.returncode == 4:
        subprocess.run(["notify-send", "rofinmcli.py", "Failed to disconnect from " + selected])
