packagemaker = '/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker'
#Used clam AV version
CLAMAV_VERSION = '0.95.1'
#Needed macports
PORTS = %w{zlib bzip2}
#sf.net mirror
SF_MIRROR = 'freefr'
source = "clamav-#{CLAMAV_VERSION}"

def sudo_rm(path)
	if File.exist? path
		sh "sudo rm -r #{path}"
	end
end

task :ports do
	installed = `port installed`
	PORTS.each do |port|
		sh "sudo port -d install #{port} +universal" if installed.index(port) == nil
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
	file "#{source}.tar.gz" do
		sh "curl -O http://#{SF_MIRROR}.dl.sourceforge.net/sourceforge/clamav/#{source}.tar.gz"
	end

	file source => "#{source}.tar.gz" do
		sh "tar -xvzf #{source}.tar.gz"
	end
	
	task :patch => source do
		Dir.chdir "#{source}/freshclam" do
			%w{freshclam manager}.each do |f|
				mv "#{f}.c", "#{f}.m" if File.exist? "#{f}.c"
			end
		end
		Dir.chdir source do
			sh "patch -p0 -N -i ../patches/freshclam.patch"
		end
	end

	task :build => [:patch, :ports] do
		if File.exist? "#{source}/clamd/clamd"
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
			Dir.chdir source do
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
		Dir.chdir source do
			sh 'sudo make install'
		end
	end

	task :clean do
		rm_r source
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

desc "Install applications and conf files"
task :install => ['palourde:install', 'clamav:install', :conf]

desc "Remove installed stuff"
task :uninstall do
	stop 'com.macbouffon.palourde.agent.plist'
	stop 'com.macbouffon.palourde.freshclam.plist'
	stop 'com.macbouffon.palourde.clamd.plist'
	sudo_rm '/Library/Palourde'
	sudo_rm '/Library/Preferences/clamd.conf'
	sudo_rm '/Library/Preferences/freshclam.conf'
	sudo_rm '/Library/LaunchAgents/net.palourde.agent.plist'
	sudo_rm '/Library/LaunchDaemons/net.palourde.clamd.plist'
	sudo_rm '/Library/LaunchDaemons/net.palourde.freshclam.plist'
	sudo_rm '/Library/LaunchAgents/com.macbouffon.palourde.agent.plist'
	sudo_rm '/Library/LaunchDaemons/com.macbouffon.palourde.clamd.plist'
	sudo_rm '/Library/LaunchDaemons/com.macbouffon.palourde.freshclam.plist'
end

task :clean => ['palourde:clean', 'clamav:clean', :uninstall] do
	rm_r 'build' if File.exist? 'build'
	rm 'Palourde.dmg' if File.exist? 'Palourde.dmg'
end

desc "compile applications"
task :build => ['palourde:build', 'clamav:build']

def chown(file)
	sh "sudo chown -R root:admin #{file}"
end

def copy_chown(file, to)
	sh "sudo cp etc/#{file} #{to}"
	chown "#{to}#{file}"
end

desc "Spread conf files"
task :conf do
	copy_chown 'clamd.conf', '/Library/Preferences/'
	copy_chown 'freshclam.conf', '/Library/Preferences/'
	copy_chown 'net.palourde.agent.plist', '/Library/LaunchAgents/'
	copy_chown 'net.palourde.clamd.plist', '/Library/LaunchDaemons/'
	copy_chown 'net.palourde.freshclam.plist', '/Library/LaunchDaemons/'
end

task :default => :dmg

desc "Build a cute package"
task :pkg => :install do
  sh 'freeze Palourde.packproj'
	#rm 'palourde.pkg' if File.exist? 'palourde.pkg'
	#sudo_rm 'package' if File.exist? 'package'
	#mkdir_p 'package/Library/Palourde'
	#mkdir_p 'package/Library/Preferences'
	#mkdir_p 'package/Library/LaunchAgents'
	#mkdir_p 'package/Library/LaunchDaemons'
	#sh 'sudo cp -r /Library/Palourde/Palourde.app package/Library/Palourde'
	#sh 'sudo chmod 775 package/Palourde.app'
	#sh 'cp -p /Library/Preferences/clamd.conf package/Library/Preferences/'
	#sh 'cp -p /Library/Preferences/freshclam.conf package/Library/Preferences/'
	#sh 'cp -p /Library/LaunchAgents/net.palourde.agent.plist package/Library/LaunchAgents/'
	#sh 'cp -p /Library/LaunchDaemons/net.palourde.clamd.plist package/Library/LaunchDaemons/'
	#sh 'cp -p /Library/LaunchDaemons/net.palourde.freshclam.plist package/Library/LaunchDaemons/'
	#sh 'find package -name ".DS_Store" -exec rm -f {} \;'
	#chown 'package'
	#sh "#{packagemaker} --root ./package --id net.palourde --out Palourde.pkg --version 0.1 --title Palourde --domain system --root-volume-only --verbose --discard-forks --scripts pkg_scripts --install-to /"
	#--scripts pkg_scripts
	#--target 10.5
end

desc "Build an image file"
task :dmg => :pkg do
	rm_r 'dmg' if File.exist? 'dmg'
	mkdir 'dmg'
	cp_r 'build/Palourde.pkg', 'dmg'
	rm 'Palourde.dmg' if File.exist? 'Palourde.dmg'
	sh 'hdiutil create -volname Palourde -srcfolder dmg Palourde.dmg'
	rm_r 'dmg'
end
  
task :start do
	sh "sudo launchctl load -w /Library/LaunchDaemons/com.macbouffon.palourde.clamd.plist"
end

desc 'Update virus definition'
task :freshclam do
	sh "sudo /Library/Palourde/Palourde.app/Contents/Resources/bin/freshclam --config-file=/Library/Preferences/clamd.conf --daemon-notify"
end