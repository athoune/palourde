task :i18n do
	sh 'genstrings source/PAController.m'
end

task :build do
	sh 'xcodebuild -target Palourde -configuration Release'
end

task :clean do
	sh 'xcodebuild clean'
end

task :clamav do
	export = { 
		'CFLAGS'=> '-O0 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch ppc -arch i386 -mmacosx-version-min=10.5',
		'CPPFLAGS'=> '-I/opt/local/include -isysroot /Developer/SDKs/MacOSX10.5.sdk',
		'CXXFLAGS'=> '-O2 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch ppc -arch i386 -mmacosx-version-min=10.5',
		'MACOSX_DEPLOYMENT_TARGET'=> '10.5',
		'CPP'=> '/usr/bin/cpp-4.0',
		'CXX'=> '/usr/bin/g++-4.0',
		'F90FLAGS'=> '-O2',
		'LDFLAGS'=> '-L/opt/local/lib -arch ppc -arch i386 -mmacosx-version-min=10.5',
		'FCFLAGS'=> '-O2',
		'OBJC'=> '/usr/bin/gcc-4.0',
		'INSTALL'=> '/usr/bin/install -c',
		'OBJCFLAGS'=> '-O2',
		'FFLAGS'=> '-O2',
		'CC'=> '/usr/bin/gcc-4.0'
	}
	Dir.chdir 'clamav-src' do
		sh './configure --enable-static --with-zlib=/opt/local --with-libbz2-prefix=/opt/local --with-iconv --prefix=/Library/Palourde/Palourde.app/Contents/Resources --disable-clamav --disable-dependency-tracking --sysconfdir=/Library/Preferences/ --with-dbdir=/Library/Palourde/Definitions/'
		sh 'make clean'
		cmd = ''
		export.each do |k,v|
			cmd += "#{k}='#{v}' "
		end
		sh "#{cmd} make all"
		sh 'sudo make install'
	end
end

task :install do
	sh 'sudo mkdir -p /Library/Palourde/'
	sh 'sudo rm -r /Library/Palourde/Palourde.app'
	sh 'sudo cp -r build/Release/Palourde.app /Library/Palourde/'
end

task :conf do
	sh 'sudo cp etc/clamd.conf /Library/Preferences/'
	sh 'sudo cp etc/freshclam.conf /Library/Preferences/'
	sh 'sudo cp etc/com.macbouffon.palourde.agent.plist /Library/LaunchAgents/'
	sh 'sudo cp etc/com.macbouffon.palourde.clamd.plist /Library/LaunchDaemons/'
	sh 'sudo cp etc/com.macbouffon.palourde.freshclam.plist /Library/LaunchDaemons/'
end

task :start do
	sh "sudo launchctl load -w /Library/LaunchDaemons/com.macbouffon.palourde.clamd.plist"
	
end

task :update do
	sh "sudo /Library/Palourde/Palourde.app/Contents/Resources/bin/freshclam --config-file=/Library/Preferences/clamd.conf --daemon-notify"
end