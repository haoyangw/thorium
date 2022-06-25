#!/bin/bash

# Copyright (c) 2022 Alex313031.

YEL='\033[1;33m' # Yellow
RED='\033[1;31m' # Red
GRE='\033[1;32m' # Green
c0=$'\033[0m' # Reset Text
bold=$'\033[1m' # Bold Text
underline=$'\033[4m' # Underline Text

# Error handling
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "${RED}Failed $*"; }

printf "\n" &&
printf "${YEL}Installing depot_tools, cloning Thorium repo, and creating Chromium directories...\n" &&
tput sgr0 &&
sleep 1 &&

cd $HOME &&
# Clone repos
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git &&

git clone https://github.com/Alex313031/Thorium.git &&

# Make Chromium dirs
mkdir -v $HOME/chromium &&
mkdir -v $HOME/chromium/win &&
cd $HOME/chromium/win &&

printf "\n" &&
printf "${YEL}Downloading Cross-Building MSVS Artifacts Archive...\n" &&
tput sgr0 &&
sleep 1 &&

# Download VS artifacts .zip
wget -v https://github.com/Alex313031/Snippets/releases/download/10.1.20348.1_02/4bc2a30e80.zip &&
sleep 1 &&

# Alert user to .bashrc changes
printf "\n" &&
printf "${YEL}Adding these lines to your .bashrc...\n" &&
tput sgr0 &&
printf "umask 022\n" &&
printf "PATH=$PATH:~/depot_tools\n" &&
printf "export DEPOT_TOOLS_WIN_TOOLCHAIN_BASE_URL=~/chromium/win/\n" &&
printf "export GYP_MSVS_HASH_1023ce2e82=4bc2a30e80\n" &&

# Give user a chance to stop if they wish
read -p "Press Enter to continue, otherwise use Ctrl + C to stop."

cd $HOME &&
# Append lines to .bashrc
echo 'umask 022' >> .bashrc &&

echo 'PATH="$PATH:~/depot_tools"' >> .bashrc &&

echo 'export DEPOT_TOOLS_WIN_TOOLCHAIN_BASE_URL=~/chromium/win/' >> .bashrc &&

echo 'export GYP_MSVS_HASH_1023ce2e82=4bc2a30e80' >> .bashrc &&

printf "\n" &&
printf "${YEL}Running source ~/.bashrc..\n" &&
tput sgr0 &&

# Source .bashrc so changes take effect
source ~/.bashrc &&

printf "\n" &&
printf "${YEL}Downloading Chromium source (This will take a while)...\n" &&
tput sgr0 &&
sleep 1 &&

# Use depot_tools fetch to download full Chromium source tree
cd ~/chromium &&

fetch --nohooks chromium &&

printf "\n" &&
printf "${YEL}Running install-build-deps.sh to make sure prerequisites are installed...\n" &&
tput sgr0 &&

# Run script to install needed libraries
cd ~/chromium/src &&
sudo dpkg --add-architecture i386 &&

./build/install-build-deps.sh --lib32 --arm --chromeos-fonts &&

printf "\n" &&
printf "${YEL}Running hooks...\n" &&
tput sgr0 &&

# Run hooks for Chromium
cd ~/chromium/src &&
gclient runhooks &&

# Alert user to .gclient file changes
printf "\n" &&
printf "${YEL}Appending target_os = [ 'linux', 'win' ] to .gclient file...\n" &&
tput sgr0 &&

cd ~/chromium &&
# Apend line to chromium/.gclient file
echo "target_os = [ 'linux', 'win' ]" >> .gclient &&

printf "\n" &&
printf "${YEL}Running trunk.sh in ~/Thorium...\n" &&
tput sgr0 &&

# Make set_exec.sh executable so it can make all other scripts executable
cd ~/Thorium &&
chmod +x set_exec.sh &&

# Run set_exec.sh
./set_exec.sh &&

# Run final trunk.sh to sync/rebase everything with tags and branches, and to set the VS toolchain
./trunk.sh &&

# Land user in ~/chromium/src
cd ~/chromium/src

printf "${YEL}Done!\n" &&

printf "${GRE}Done! ${YEL}You can now run ./setup.sh or build vanilla Chromium.\n"
tput sgr0

exit 0