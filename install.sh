#!/bin/sh

cp -r build/Release/Palourde.app /Library/Palourde/
cp clamd.conf /Library/Palourde/etc/
cp com.macbouffon.palourde.agent.plist /Library/LaunchAgents/
cp com.macbouffon.palourde.clamd.plist /Library/LaunchDaemons/
cp com.macbouffon.palourde.freshclam.plist /Library/LaunchDaemons/
