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
# TODO(spesnova):
#   Maybe using `pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI` is better to check.
if File.exists?('/var/db/receipts/com.apple.pkg.DeveloperToolsCLI.plist')
  success "Xcode Command Line Tools found."
else
  fail "You need to install Xcode Command Line Tools. You can find and download it:"
  puts "    from: #{Tty.underline 39} https://developer.apple.com/downloads/index.action#{Tty.reset}"
  puts "    Type 'command' in search box and download latest one."
  system "open", "https://developer.apple.com/downloads/index.action"
  exit
end

#
# Check for Homebrew
#
if File.exists?('/usr/local/bin/brew') && File.executable?('/usr/local/bin/brew')
  success "Homebrew found."
else
  warn "You need to install Homebrew."
  ask "Can I install Homebrew? [y]es, [n]o?:"
  answer = STDIN.gets.chomp

  if answer == "y"
    success "Installing Homebrew..."
    separator "install script's output"
    system('ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"')
    exit 1 if $? != 0
    puts ""
  else
    puts ""
    exit
  end
end

#
# Install Homebrew Formula and Casks
#
if File.exists?('homebrew/Brewfile')
  success "Installing your formulas and casks..."
  separator "brew command's output"
  Dir.chdir "#{ROOT_DIR}/homebrew"
  system("brew bundle")
  exit 1 if $? != 0
  puts ""

  Dir.chdir ROOT_DIR
end

#
# Install Ruby
#
# TODO

#
# Check for Bundler
#
if File.executable?("#{ENV['HOME']}/.rbenv/shims/bundle")
  success "Bundler found."
else
  warn "You need to install Bundler."
  ask "Can I install Bundler gem? [y]es, [n]o?:"
  answer = STDIN.gets.chomp

  if answer == "y"
    success "Installing bundler..."
    separator "gem command's output"
    system("#{ENV['HOME']}/.rbenv/shims/gem install bundler --no-ri --no-rdoc")
    exit 1 if $? != 0
    puts ""
  else
    exit
  end
end

#
# Install Gems
#
if File.exists?('ruby/Gemfile') || File.exists?('ruby/Gemfile.lock')
  success "Installing your rubies..."
  separator "bundle command's output"
  Dir.chdir "#{ROOT_DIR}/ruby"
  system("#{ENV['HOME']}/.rbenv/shims/bundle install")
  exit 1 if $? != 0
  puts ""

  Dir.chdir ROOT_DIR
end

#
# Check for Some Accounts like hipchat, github
#
# TODO

#
# Startup Instructions
#
puts ""
puts "  Good work. You're ready."
