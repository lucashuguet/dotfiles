#!/usr/bin/env python3

import subprocess

current = subprocess.check_output(["pactl", "get-default-sink"]).decode("utf-8").strip()
output = subprocess.check_output(["pactl", "list", "sinks"]).decode("utf-8")
sections = output.split("\n\n")

print(current)

sinks = []

for section in sections:
    if "Name: " in section and "device.description" in section:
        name = section.split("Name: ")[1].split("\n")[0]
        description = section.split('device.description = "')[1].split('"')[0]

        if description not in [s["description"] for s in sinks]:
            sinks.append({"name": name, "description": description})

for sink in sinks:
    if sink["name"] == current:
        sink["description"] = sink["description"] + " (current)"

descriptions = [s["description"] for s in sinks]

inputs = "\n".join(descriptions)
selected_description = subprocess.check_output(["rofi", "-dmenu"], text=True, input=inputs).strip()

if not "current" in selected_description:
    selected_sink = next((s for s in sinks if s["description"] == selected_description), None)

    if selected_sink:
        sink = selected_sink["name"]
        subprocess.run(["mpc", "pause"])
        subprocess.run(["pactl", "set-default-sink", sink])

        subprocess.run(["notify-send", "rofisink.py", "sink changed"])
    else:
        exit(1)
