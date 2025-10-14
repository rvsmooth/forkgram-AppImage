#!/bin/bash

IMGTOOL_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
IMGTOOL="aitool"
FORKGRAM_URL="https://github.com/forkgram/tdesktop/releases/download/v6.2.3/Telegram.tar.xz"
FORKGRAM="forkgram.7z"
DIR_STR="AppDir/usr/bin"

# get deps
wget -O "$IMGTOOL" "$IMGTOOL_URL"
wget -O "$FORKGRAM" "$FORKGRAM_URL"
chmod +x "$IMGTOOL"

# Create directory structure
mkdir -p "$DIR_STR"

# Extract forkgram archive
7z x "$FORKGRAM"
mv Telegram "$DIR_STR"/forkgram
cp forkgram.desktop AppDir/
cp run.sh AppDir/AppRun
cp org.forkgram.desktop.png AppDir/

ARCH=x86_64 ./"$IMGTOOL" AppDir forkgram.AppImage
