#!/bin/sh

/Library/Palourde/Palourde.app/Contents/Resources/bin/freshclam
launchctl load -w /Library/LaunchDaemons/com.macbouffon.palourde.clamd.plist
launchctl load -w /Library/LaunchAgents/com.macbouffon.palourde.agent.plist
launchctl start com.macbouffon.palourde.clamd
launchctl start com.macbouffon.palourde.agent
mkdir /Library/Palourde/Definitions