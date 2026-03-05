#!/bin/bash
set -x
IMGTOOL_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
IMGTOOL="aitool"
TAG=$(curl -s https://api.github.com/repos/forkgram/tdesktop/releases/latest | jq -r '.tag_name')
FORKGRAM_URL=$(curl -s 'https://api.github.com/repos/forkgram/tdesktop/releases' | jq -r --arg tag "$TAG" '.[] | select(.tag_name == $tag) | .assets[] | select(.name | endswith(".tar.xz")) | .browser_download_url')
FORKGRAM="forkgram.tar.xz"
DIR_STR="AppDir/usr/bin"

build() {
  # get deps
  wget -O "$IMGTOOL" "$IMGTOOL_URL"

  # make IMGTOOL executable
  chmod +x "$IMGTOOL"

  # Create directory structure
  mkdir -p "$DIR_STR"

  # Extract forkgram archive
  tar -xf "$FORKGRAM"

  # Prepare AppDir
  mv Telegram "$DIR_STR"/forkgram
  cp forkgram.desktop AppDir/
  cp run.sh AppDir/AppRun
  cp org.forkgram.desktop.png AppDir/

  # Build
  ARCH=x86_64 ./"$IMGTOOL" AppDir forkgram.AppImage

  # Export verison to github
  echo "FORKGRAM_VERSION=$TAG" >>$GITHUB_ENV
}

# exit if linux binary is not available on the remote repository
wget -qO "$FORKGRAM" $FORKGRAM_URL || {
  echo "Error: Didn't find forkgram-$TAG for linux on remote repo"
  exit 1
}
build
