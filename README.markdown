Palourde is a Mac antivirus with ClamAV doing the dirty job.

Ingredients
===========

 * Clamav is used vanilla, but _clamd_ and _freshclam_ are handled by _launchd_.
 * Palourde is a Cocoa application with a small C part for handling unix socket communication.
 * Build is done with a _Rakefile_

Frameworks
----------

 * [Growl](http://growl.info/) for unintrusive warnings
 * [HMBlkAppKit](http://shiira.jp/hmblkappkit/en.html) for nice HUD infos
 * [Sparkle](http://sparkle.andymatuschak.org/) for update

Install
=======

Fetch the lastest clamav sources : http://www.clamav.net/download/sources
	tar -xvzf clamav-0.95.1.tar.gz
	ln -s clamav-0.95.1 clamav-src
Build dependencies with [macports](http://www.macports.org/) 
	sudo port -d install zlib bzip2
Build palourde
	rake build
Install it
	rake install
Gives it ammo
	rake freshclam
Lauchctl notices that new agent and daemons is here to be launched. A red insecticid bottle appears on the top of your screen.

Testing it
==========

*eicar_com.zip* is a fake virus for test purpose. You can put it in an USB key and plug it, or the classical but slower *Scan home*.

Debug can be saw in the _Console_

Uninstall
=========
All the data are in _/Library/Palourde_, _freshclam.conf_ and _clamd.conf_ are in _/Library/Preferences_, two daemon's confs are in _/Library/LaunchDaemons_ and the agent is in _/Library/LaunchAgents_.

Rake does the job
	rake uninstall