#!/bin/sh

set -e

FRAMEWORK_URI=https://github.com/neonichu/ContentfulDeliveryAPIFramework/releases/download/1.2.0/ContentfulDeliveryAPI.tar.gz
PLAYGROUND_DIR="${HOME}/Library/Developer/Playground Frameworks"
PLAYGROUND_URI=https://github.com/neonichu/ContentfulDeliveryAPIFramework/releases/download/1.2.0/ContentfulPlaygrounds.tar.gz
PLUGIN_URI=https://github.com/neonichu/BBUToyUnboxing/releases/download/0.6/BBUToyUnboxing.xcplugin.tar.gz
PLUGINS_DIR="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins"

echo "Installing Xcode plug-in..."
mkdir -p "${PLUGINS_DIR}"
curl -L $PLUGIN_URI | tar xvz -C "${PLUGINS_DIR}"

echo "Downloading ContentfulDeliveryAPI.framework..."
mkdir -p "${PLAYGROUND_DIR}"
curl -L $FRAMEWORK_URI | tar xvz -C "${PLAYGROUND_DIR}"

echo "Downloading Contentful Documentation Playground..."
curl -L $PLAYGROUND_URI | tar xvz -C "${HOME}/Desktop"

echo -e "\nInstallation successful.\nPlease restart your Xcode and open the Playground after ~5 seconds."
