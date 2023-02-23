#!/usr/bin/env python3

import subprocess

output = subprocess.check_output(['pactl', 'list', 'sinks'])

output = output.decode('utf-8')

sections = output.split('\n\n')

sinks = []

for section in sections:
    if 'Name: ' in section and 'device.description' in section:
        name = section.split('Name: ')[1].split('\n')[0]
        description = section.split('device.description = "')[1].split('"')[0]
        if description not in [s['description'] for s in sinks]:
            sinks.append({'name': name, 'description': description})

descriptions = [s['description'] for s in sinks]

inputs = '\n'.join(descriptions)
selected_description = subprocess.check_output(['rofi', '-dmenu'], text=True, input=inputs).strip()

selected_sink = next((s for s in sinks if s['description'] == selected_description), None)
if selected_sink:
    sink = selected_sink['name']
    subprocess.run(["pactl", "set-default-sink", sink])
else:
    exit(1)
