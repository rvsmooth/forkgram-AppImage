#!/usr/bin/env bash
set -euo pipefail

APPIMAGE_NAME="forkgram.AppImage"
DEFAULT_DOWNLOAD_URL="https://github.com/forkgram/AppImage/releases/latest/download/${APPIMAGE_NAME}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

PREFIX="${PREFIX:-}"
if [[ -z "${PREFIX}" ]]; then
  if [[ $(id -u) -eq 0 ]]; then
    PREFIX="/usr/local"
  else
    PREFIX="$HOME/.local"
  fi
fi

BIN_DIR="$PREFIX/bin"
DATA_DIR="${XDG_DATA_HOME:-$PREFIX/share}"
APP_DATA_DIR="$DATA_DIR/forkgram"
APPLICATIONS_DIR="$DATA_DIR/applications"
ICON_DIR="$DATA_DIR/icons/hicolor/512x512/apps"

APPIMAGE_TARGET="$APP_DATA_DIR/$APPIMAGE_NAME"
DESKTOP_TARGET="$APPLICATIONS_DIR/forkgram.desktop"
ICON_TARGET="$ICON_DIR/org.forkgram.desktop.png"
DOWNLOAD_URL="${APPIMAGE_URL:-$DEFAULT_DOWNLOAD_URL}"
SOURCE_APPIMAGE="${1:-}"

mkdir -p "$BIN_DIR" "$APP_DATA_DIR" "$APPLICATIONS_DIR" "$ICON_DIR"

if [[ -n "$SOURCE_APPIMAGE" ]]; then
  if [[ ! -f "$SOURCE_APPIMAGE" ]]; then
    echo "Provided AppImage '$SOURCE_APPIMAGE' was not found" >&2
    exit 1
  fi
  install -m755 "$SOURCE_APPIMAGE" "$APPIMAGE_TARGET"
elif [[ -f "$SCRIPT_DIR/$APPIMAGE_NAME" ]]; then
  install -m755 "$SCRIPT_DIR/$APPIMAGE_NAME" "$APPIMAGE_TARGET"
else
  echo "Downloading latest AppImage from $DOWNLOAD_URL"
  curl -L -o "$APPIMAGE_TARGET" "$DOWNLOAD_URL"
  chmod 755 "$APPIMAGE_TARGET"
fi

install -m644 "$SCRIPT_DIR/forkgram.desktop" "$DESKTOP_TARGET"
install -m644 "$SCRIPT_DIR/org.forkgram.desktop.png" "$ICON_TARGET"

ln -sf "$APPIMAGE_TARGET" "$BIN_DIR/forkgram"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APPLICATIONS_DIR" >/dev/null 2>&1 || true
fi

if command -v update-icon-caches >/dev/null 2>&1; then
  update-icon-caches "$ICON_DIR" >/dev/null 2>&1 || true
elif command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache "$DATA_DIR/icons" >/dev/null 2>&1 || true
fi

echo "Forkgram installed to $APPIMAGE_TARGET"
echo "Binary link created at $BIN_DIR/forkgram"
