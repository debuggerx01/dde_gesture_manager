#!/usr/bin/env bash

VERSION=$(dart version.dart)

if [ -e pubspec.yaml.bak ]; then
    mv pubspec.yaml.bak pubspec.yaml
fi

flutter clean

cp pubspec.yaml pubspec.yaml.bak
ln -s /usr/share/fonts/opentype/noto/ noto_fonts

cat >> pubspec.yaml << EOF
  fonts:
    - family: NotoSansSC
      fonts:
        - asset: noto_fonts/NotoSansCJK-Regular.ttc
          weight: 400
        - asset: noto_fonts/NotoSansCJK-Bold.ttc
          weight: 700

EOF

flutter build linux

rm pubspec.yaml
rm noto_fonts
mv pubspec.yaml.bak pubspec.yaml

if [ -e deb_builder ]; then
    rm -rf deb_builder
fi

ARCH="x64"

if [[ $(uname -m) == aarch64 ]]; then
  ARCH="arm64"
fi

mkdir "deb_builder"

cp -r debian deb_builder/DEBIAN
chmod -R 755 deb_builder/DEBIAN
cp ../LICENSE deb_builder/DEBIAN/copyright

echo Version: "$VERSION" >> deb_builder/DEBIAN/control

mkdir -p deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/

cp -r build/linux/"$ARCH"/release/bundle deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/files

rm -rf deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/files/data/flutter_assets/noto_fonts/

ln -s /usr/share/fonts/opentype/noto/ deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/files/data/flutter_assets/noto_fonts

cp -r dde_package_info/* deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/

mkdir -p deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/entries/icons/hicolor/scalable/apps/

cp web/icons/Icon-512.png deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/entries/icons/hicolor/scalable/apps/dgm.png

sed -i "s/VERSION/$VERSION/g" deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/info

sed -i "s/VERSION/$VERSION/g" deb_builder/opt/apps/com.debuggerx.dde-gesture-manager/entries/applications/com.debuggerx.dde-gesture-manager.desktop

dpkg-deb -b deb_builder

mv deb_builder.deb dgm-"$VERSION"_"$ARCH".deb
