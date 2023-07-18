#!/bin/bash
disk_size_bytes=$(lsblk -b -o SIZE -n -d $(disk))
disk_size_gib=$(numfmt --to=iec-i --suffix=B --format="%.1f" $disk_size_bytes)
echo $disk_size_gib