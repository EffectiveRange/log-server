#!/bin/bash

# Get the latest release version string
VERSION=$(curl --silent -qI https://github.com/vrince/arm-beats/releases/latest \
| awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}') VERSION=${VERSION#v}

# Get the filebeat binary for armhf
if [ ! -f "filebeat-${VERSION}-linux-armv6l.tar.gz" ]; then
  wget https://github.com/vrince/arm-beats/releases/download/v${VERSION}/filebeat-${VERSION}-linux-armv6l.tar.gz
fi

# Extract the filebeat binary
rm -rf filebeat-${VERSION}-linux-armv6l
tar -xf filebeat-${VERSION}-linux-armv6l.tar.gz

# Copy the filebeat binary to the package directory
mkdir -p filebeat_${VERSION}-1_armhf/usr/bin
cp filebeat-${VERSION}-linux-armv6l/filebeat filebeat_${VERSION}-1_armhf/usr/bin/

# Set up file permissions
chown root filebeat_${VERSION}-1_armhf/usr/share/filebeat/filebeat.yml
chmod 755 filebeat_${VERSION}-1_armhf/DEBIAN/postinst

# Build the package
dpkg-deb --build filebeat_${VERSION}-1_armhf
