#!/usr/bin/env bash
# Downloads WASM locally and use local fonts
# Temporary solution until https://github.com/flutter/flutter/issues/70101 and 77580 provide a better way
flutter clean
flutter build web
wasmLocation=$(grep canvaskit-wasm build/web/main.dart.js | sed -e 's/.*https/https/' -e 's/\/bin.*/\/bin/' | uniq)
echo "Downloading WASM from $wasmLocation"
curl -o build/web/canvaskit.js "$wasmLocation/canvaskit.js"
curl -o build/web/canvaskit.wasm "$wasmLocation/canvaskit.wasm"
sed -i -e "s!$wasmLocation!.!" \
  -e "s!https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Me5WZLCzYlKw.ttf!./google_fonts/Roboto-Regular.ttf!" \
  -e "s!https://fonts.googleapis.com/css2?family=Noto+Sans+Symbols!./assets/assets/css/Noto-Sans-Symbols.css!" \
  -e "s!https://fonts.googleapis.com/css2?family=Noto+Color+Emoji+Compat!./assets/assets/css/Noto-Color-Emoji-Compat.css!" \
  build/web/main.dart.js
