#!/bin/sh

#  BuildScript.sh
#  SGPSIReader
#
#  Created by nayminsoe on 2/11/17.
#  Copyright © 2017 nayminsoe. All rights reserved.

#Firstly run 'xcode-select --install' in terminal if you have not done yet
#Name: Dev_SGPSIReader
#Name: Auto sign -> 'iOS Team Provisioning Profile: *'

xcodebuild -scheme SGPSIReader -workspace SGPSIReader/SGPSIReader.xcworkspace clean archive -archivePath build/SGPSIReader
xcodebuild -exportArchive -exportFormat ipa -archivePath "build/SGPSIReader.xcarchive" -exportPath "Deliverables/SGPSIReader.ipa" -exportProvisioningProfile 'Dev_SGPSIReader'
