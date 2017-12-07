#!/bin/bash

version=$1
CMD=""
if [[ -n "$version" ]]; then
      CMD="scp mkorcy01@estsvuebuild-prod-01.uit.tufts.edu:/usr/local/jenkins/vue/$version/VUE.app.zip ."
      $CMD
      unzip VUE.app.zip
      rm ./VUE.app.zip
#      /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier edu.tufts.tts.ests.VUE" ./VUE.app/Contents/Info.plist
      codesign -f -s "Developer ID Application" ./VUE.app
      spctl --assess --verbose=4 ./VUE.app
      productbuild --component "VUE.app" /Applications --sign "Developer ID Installer" VUE.pkg
      rm -rf ./VUE.app
      CMD="scp VUE.pkg mkorcy01@estsvuebuild-prod-01.uit.tufts.edu:/usr/local/jenkins/vue/$version/"
      $CMD
      rm VUE.pkg
else
      echo "argument error: requires version"
fi
