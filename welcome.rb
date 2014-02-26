#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
#
# Welcome
#
# Bootstrap Your Mac

ROOT_DIR = File.expand_path(File.dirname(__FILE__))

module Tty extend self
  def green; bold 32; end
  def yellow; bold 33; end
  def blue; bold 34; end
  def white; bold 39; end
  def red; bold 31; end
  def reset; escape 0; end
  def bold n; escape "1;#{n}" end
  def underline n; escape "4;#{n}" end
  def escape n; "\033[#{n}m" if STDOUT.tty? end
end

def success(string)
  puts "  #{Tty.green}+#{Tty.reset} #{string}"
end

def separator(string)
  puts "=======================> #{string}"
  puts ""
end

def warn(string)
  puts "  #{Tty.yellow}-#{Tty.reset} #{string}"
end

def ask(string)
  print "  #{Tty.yellow}?#{Tty.reset} #{string} "
end

def fail(string)
  puts "  #{Tty.red}x#{Tty.reset} #{string}"
end

def macos_version
  @macos_version ||= `/usr/bin/sw_vers -productVersion`.chomp[/10\.\d+/]
end

#
# Welcome to Welcome
#
puts ""
puts "  Welcome"
puts "    Bootstrap Your Mac."
puts ""

Dir.chdir ROOT_DIR

#
# Check for Max OS X Version.
#
unless macos_version.to_f >= 10.8
  fail "You must be on Mountain Lion or greater!"
  puts ""
  exit 1
end

#
# Check for Running User.
#
if Process.uid == 0
  fail "Don't run this as root!"
  puts ""
  exit 1
end

#
# Check for Running User Group.
#
unless `groups`.split.include? "admin"
  fail "This script requires the user #{ENV['USER']} to be an Administrator."
  puts ""
  exit 1
end

#
# Check for XCode
#
if File.exists?('/usr/bin/xcodebuild') && File.exists?('/Applications/Xcode.app')
  success "Xcode 5 found." if /^Xcode 5/.match(`/usr/bin/xcodebuild -version`)
else
  fail "You need to install Xcode first. You can download it:"
  puts "    from: #{Tty.underline 39}https://itunes.apple.com/us/app/xcode/id497799835#{Tty.reset}"
  puts ""
  system "open", "https://itunes.apple.com/us/app/xcode/id497799835"
  exit
end

#
# Check for Xcode Command Line Tools
#
system("pkgutil --pkg-info=com.apple.pkg.CLTools_Executables > /dev/null 2>&1")
if $? == 0
  success "Xcode Command Line Tools found."
else
  warn "You need to install Xcode Command Line Tools."
  ask  "Can I install Xcode Command Line Tools? [y]es, [n]o?:"
  answer = STDIN.gets.chomp
  if answer == "y"
    success "Installing xcode-select..."
    separator "install script's output"
    system("xcode-select --install")
    exit 1 if $? != 0
    puts ""
  else
    puts ""
    exit
  end
end

#
# Check for Chef
#
if File.exists?('/opt/chef') && File.executable?('/opt/chef/bin/chef-client')
  success "Chef found."
else
  warn "You need to install Chef."
  ask  "Can I install Chef? [y]es, [n]o?:"
  answer = STDIN.gets.chomp
  if answer == "y"
    success "Installing Chef..."
    separator "install script's output"
    # TODO (spesnova):
    #   Use '#curl -L https://www.opscode.com/chef/install.sh | sudo bash'
    #   if original script supports os x 10.9
    system("curl -L https://gist.github.com/ringohub/7660676/raw/bc25c3274d55a799f11e4aa012bf3e809a7cf285/install.sh | sudo bash")
    exit 1 if $? != 0
    puts ""
  else
    puts ""
    exit
  end
end

#
# Check for Berkshelf
#
if File.executable?('/opt/chef/embedded/bin/berks')
  success "Berkshelf found."
else
  warn "You need to install Berkshelf."
  success "Installing berkshelf..."
  separator "install output"
  system("sudo /opt/chef/embedded/bin/gem install berkshelf --no-ri --no-rdoc")
end

#
# Run Berkshelf
#
if File.executable?('/opt/chef/embedded/bin/berks') && File.exists?("#{ROOT_DIR}/chef/Berksfile")
  Dir.chdir "#{ROOT_DIR}/chef"

  success "Installing chef cookbooks..."
  separator "install output"
  system("/opt/chef/embedded/bin/berks install --path #{ROOT_DIR}/chef/cookbooks")

  Dir.chdir "#{ROOT_DIR}"
end

#
# Run Chef
#
#system("sudo /usr/bin/chef-solo -c #{ROOT_DIR}/chef/solo.rb")

#
# Startup Instructions
#
puts ""
puts "  Good work. You're ready."
