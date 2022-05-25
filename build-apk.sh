#!/bin/bash 
PATH_PROJECT=$(pwd)

# build apk
#flutter clean
# flutter pub get
flutter build apk --release

# move file app-release.apk to root folder
# keytool -list -v -keystore key.jks -alias key
# https://flutter.dev/docs/deployment/android#create-a-keystore
cp "$PATH_PROJECT/build/app/outputs/flutter-apk/app-release.apk" "$PATH_PROJECT/smart market.apk"