#!/usr/bin/env bash

VERSION=$(dart version.dart)

flutter clean
flutter build linux

if [ -e deb_builder ]; then
    rm -rf deb_builder
fi

mkdir "deb_builder"

cp -r debian deb_builder/DEBIAN
cp ../LICENSE deb_builder/DEBIAN/copyright

echo Version: "$VERSION" >> deb_builder/DEBIAN/control

mkdir -p deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/

cp -r build/linux/x64/release/bundle deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/files

cp -r dde_package_info/* deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/

mkdir -p deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/entries/icons/hicolor/scalable/apps/

cp web/icons/Icon-512.png deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/entries/icons/hicolor/scalable/apps/dgm.png

sed -i "s/VERSION/$VERSION/g" deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/info

sed -i "s/VERSION/$VERSION/g" deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/entries/applications/com.debuggerx.dde-gesture-manager.desktop

dpkg-deb -b deb_builder

mv deb_builder.deb dgm-"$VERSION"_x64.deb
