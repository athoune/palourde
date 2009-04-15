Palourde is a Mac antivirus with ClamAV doing the dirty job.

Ingredients
===========

 * Clamav is used vanilla, but _clamd_ and _freshclam_ are handled by _launchd_.
 * Palourde is a Cocoa application with a small C part for handling unix socket communication.
 * Build is done with a _Rakefile_

Install
=======

Fetch the lastest clamav sources : http://www.clamav.net/download/sources
	tar -xvzf clamav-0.95.1.tar.gz
	ln -s clamav-0.95.1 clamav-src
Build dependences with macports 
	sudo port -d install zlib bzip2
Build palourde
	rake build
Install it
	sudo rake install