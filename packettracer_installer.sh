#!/bin/bash

# Exit the script on any error
set -euo pipefail

show_help() {
    echo 'Usage: sudo ./packettracer_installer.sh <packettracer.deb>'
    echo 'Installs Cisco Packet Tracer from a .deb package on Arch Linux.'
}

if [[ "${1:-}" == '--help' || "${1:-}" == '-h' ]]; then
    show_help
    exit 0
fi

if [ "$EUID" -ne 0 ]; then
    echo 'To install Packet Tracer, root privileges are required. Please run this script with sudo.'
    exit 1
elif [ -z "${1:-}" ]; then
    echo -e 'No Packet Tracer .deb file provided.\n'
    show_help
    exit 1
fi

packettracer_binary="$1"

if [ ! -f "$packettracer_binary" ]; then
    echo "File not found: $packettracer_binary"
    exit 1
elif ! command -v ar > /dev/null 2>&1; then
    echo "'ar' command not found. Please install 'binutils' package first."
    exit 1
fi

tmpdir=$(mktemp -d)

# Remove the tmpdir on error
cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

echo 'Extracting deb package...'
cp "$packettracer_binary" "$tmpdir"
(cd "$tmpdir" && ar x "$packettracer_binary")

# Check if the data archieve was extracted
if [ ! -f "$tmpdir/data.tar.xz" ]; then
    echo 'Invalid Packet Tracer file (data.tar.xz not found).'
    exit 1
fi

echo 'Extracting data.tar.xz...'
tar -xf "$tmpdir/data.tar.xz" -C "$tmpdir"

# Check if the file data contains valid data
if [ ! -d "$tmpdir/usr/" ] ||
    [ ! -d "$tmpdir/usr/share/" ] ||
    [ ! -d "$tmpdir/usr/share/icons/" ] ||
    [ ! -d "$tmpdir/usr/share/mime/" ] ||
    [ ! -d "$tmpdir/opt/" ] ||
    [ ! -d "$tmpdir/opt/pt/" ]; then
    echo 'Invalid Packet Tracer file data.'
    exit 1
fi

# Install dependencies
echo 'Installing dependencies...'
pacman -S --needed --noconfirm \
  qt5-networkauth qt5-base qt5-multimedia qt5-websockets qt5-webengine qt5-svg qt5-speech qt5-script \
  gstreamer gst-plugins-base nss alsa-lib openssl-1.1

# Copy data (force overwrite, preserve permissions)
echo 'Copying Packet Tracer files...'
cp -rf "$tmpdir/opt/pt" /opt/
cp -rf "$tmpdir/usr/." /usr/

if [ ! -x /opt/pt/bin/PacketTracer ]; then
    chmod +x /opt/pt/bin/PacketTracer
fi

# Create a desktop entry
echo 'Creating desktop entry...'
cat <<EOF > /usr/share/applications/packettracer.desktop
[Desktop Entry]
Name=Cisco Packet Tracer
Comment=Networking Simulation Tool
Exec=/opt/pt/bin/PacketTracer
Icon=/opt/pt/art/app.png
Type=Application
Categories=Education;Network;
Terminal=false
StartupNotify=true
EOF
chmod 644 /usr/share/applications/packettracer.desktop

echo 'Successfully installed Packet Tracer.'
