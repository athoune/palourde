packagemaker = '/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker'

def sudo_rm(path)
	if File.exist? path
		sh "sudo rm -r #{path}"
	end
end


namespace :palourde do
	task :i18n do
		sh 'genstrings source/PAController.m'
	end

	task :build do
		sh 'xcodebuild -target Palourde -configuration Release'
	end

	task :clean do
		sh 'xcodebuild clean'
	end

	task :install => :build do
		sh 'sudo mkdir -p /Library/Palourde/'
		sudo_rm '/Library/Palourde/Palourde.app'
		sh 'sudo cp -r build/Release/Palourde.app /Library/Palourde/'
	end
	
end

namespace :clamav do

	task :build do
		if File.exist? 'clamav-src/clamd/clamd'
			puts "[Info] deja fait"
		else
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
				sh './configure --enable-static --with-zlib=/opt/local --with-libbz2-prefix=/opt/local --with-iconv --prefix=/Library/Palourde/Palourde.app/Contents/Resources --disable-clamav --disable-dependency-tracking --sysconfdir=/Library/Preferences/ --with-dbdir=/Library/Palourde/Definitions/ --enable-id-check --enable-clamdtop '
				sh 'make clean'
				cmd = ''
				export.each do |k,v|
					cmd += "#{k}='#{v}' "
				end
				sh "#{cmd} make all"
			end
		end
	end
	
	task :install => :build do
		Dir.chdir 'clamav-src' do
			sh 'sudo make install'
		end
	end

	task :clean do
		Dir.chdir 'clamav-src' do
			sh 'make clean'
		end
	end
end


def stop(name)
	if `launchctl list`.include? name
		sh "sudo launchctl stop #{name}"
	end
end

def launchctl(action, file)
	if File.exist? file
		sh "sudo launchctl #{action} #{file}"
	end
end

task :install => ['palourde:install', 'clamav:install', :conf]

task :uninstall do
	stop 'com.macbouffon.palourde.agent.plist'
	stop 'com.macbouffon.palourde.freshclam.plist'
	stop 'com.macbouffon.palourde.clamd.plist'
	sudo_rm '/Library/Palourde'
	sudo_rm '/Library/Preferences/clamd.conf'
	sudo_rm '/Library/Preferences/freshclam.conf'
	sudo_rm '/Library/LaunchAgents/com.macbouffon.palourde.agent.plist'
	sudo_rm '/Library/LaunchDaemons/com.macbouffon.palourde.clamd.plist'
	sudo_rm '/Library/LaunchDaemons/com.macbouffon.palourde.freshclam.plist'
end

task :clean => ['palourde:clean', 'clamav:clean', :uninstall]

task :build => ['palourde:build', 'clamav:build']

def chown(file)
	sh "sudo chown root:admin #{file}"
end

def copy_chown(file, to)
	sh "sudo cp etc/#{file} #{to}"
	chown "#{to}#{file}"
end

desc "Spread conf files"
task :conf do
	copy_chown 'clamd.conf', '/Library/Preferences/'
	copy_chown 'freshclam.conf', '/Library/Preferences/'
	copy_chown 'com.macbouffon.palourde.agent.plist', '/Library/LaunchAgents/'
	copy_chown 'com.macbouffon.palourde.clamd.plist', '/Library/LaunchDaemons/'
	copy_chown 'com.macbouffon.palourde.freshclam.plist', '/Library/LaunchDaemons/'
end

task :default => [:install]

task :pkg => :install do
	rm 'palourde.pkg' if File.exist? 'palourde.pkg'
	sudo_rm 'build/Palourde.app'
	sh 'sudo cp -r /Library/Palourde/Palourde.app build/'
	sh 'sudo chmod 775 build/Palourde.app'
	chown 'build/Palourde.app'
	sh "#{packagemaker} --doc Palourde.pmdoc "
end

task :start do
	sh "sudo launchctl load -w /Library/LaunchDaemons/com.macbouffon.palourde.clamd.plist"
	
end

desc 'Update virus definition'
task :freshclam do
	sh "sudo /Library/Palourde/Palourde.app/Contents/Resources/bin/freshclam --config-file=/Library/Preferences/clamd.conf --daemon-notify"
end