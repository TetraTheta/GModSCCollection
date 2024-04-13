#!/bin/bash
addon() {
  local gmad="E:/Program Files/Steam/steamapps/common/GarrysMod/bin/gmad.exe"
  local dest="E:/Program Files/Steam/steamapps/common/GarrysMod/garrysmod/addons/test"

  local small="$1"
  small="${small// /_}"
  small="${small,,}"
  small="${small//[^a-zA-Z0-9_]/}"

  "$gmad" create -folder "$1" -out ".build/${small}.gma"
  cp -fv ".build/${small}.gma" "$dest" 2>/dev/null
}
rm -rf ".build"
mkdir -p ".build"
mkdir -p "$dest"
# Create and copy addons
# addon "Decrease Sound"
# addon "Fix Map"
# addon "NPC Invasion"
# addon "Sandbox Map Sort"
# addon "SC Admin Gun"
# addon "SC Resistance Turrets"
addon "SC Tools"
read -r -s -n 1 -p "Press any key to continue..."
