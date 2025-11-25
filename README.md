# Forkgram AppImage
AppImage of the renowned [Forkgram Project](https://github.com/forkgram/tdesktop).

## build.sh
`build.sh` downloads the latest Forkgram binary tarball, unpacks it into an AppDir layout, and uses `appimagetool` to build `forkgram.AppImage`. The script also exports the detected Forkgram version so CI pipelines can publish it automatically.

## run.sh
`run.sh` is the AppImage entrypoint. It lives inside the AppDir and simply launches the bundled Forkgram binary from `$APPDIR/usr/bin/forkgram`.

## install.sh
`install.sh` copies a Forkgram AppImage into a standard location, installs the desktop entry and icon, and creates a runnable launcher on your `$PATH`.

- Default install path is user-local (`$HOME/.local`); when run as root it installs under `/usr/local`.
- If `forkgram.AppImage` is present next to the script or passed as the first argument, that file is used; otherwise the script downloads the latest release from GitHub. You can override the download URL via the `APPIMAGE_URL` environment variable.
- Icon and desktop files are installed under the appropriate XDG directories and caches are refreshed when the relevant utilities are available.

### Example usage
```bash
# Install using the AppImage in the current directory (or download the latest one)
./install.sh

# Install a specific AppImage file and target a custom prefix
PREFIX="$HOME/.local" ./install.sh /path/to/forkgram.AppImage
```

## Credits
- CI: [ivan](https://github.com/ivan-hc)
