i18n:
	genstrings source/PAController.m
agent:
	xcodebuild -target Palourde -configuration Release
clean:
	xcodebuild clean
