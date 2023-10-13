#!/usr/bin/env python3

import subprocess
import json

lsblk = subprocess.check_output(["lsblk", "-AJo", "name,label,fstype,mountpoint,size"])
lsblk = json.loads(lsblk.decode("utf-8"))

disks = []

for blockdevice in lsblk["blockdevices"]:
    for d in blockdevice["children"]:
        # if d["fstype"] is not None: # d["mountpoint"] is None and 
        if "nvme" not in d["name"]:
            disks.append([d["name"], d["fstype"], d["label"], d["mountpoint"] is not None, d["size"]])

if len(disks) == 0:
    subprocess.run(["notify-send", "rofidrives.py", "no drives found"])

rofi = []

for disk in disks:
    mounted = ""
    if disk[3]:
        mounted = " mounted"

    name = ""
    if disk[2] is not None:
        name = " " + disk[2] + ""

    rofi.append(disk[0] + " (" + disk[4] + name + mounted + ")")

inputs = "\n".join(rofi)
selected_disk = subprocess.check_output(["rofi", "-dmenu"], text=True, input=inputs).strip()

selected = selected_disk.split(" (")
device = "/dev/" + selected[0]
mounted = "mounted" in selected[1]

if mounted:
    output = subprocess.check_output(["udisksctl", "unmount", "-b", device]).decode("utf-8").strip()
else:
    output = subprocess.check_output(["udisksctl", "mount", "-b", device]).decode("utf-8").strip()

print(output)
subprocess.run(["notify-send", "rofidrives.py", output])
