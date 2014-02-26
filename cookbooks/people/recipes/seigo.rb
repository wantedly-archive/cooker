#
# Create working directory
#
directory "#{ENV['HOME']}/workspace" do
  action :create
end

#
# Install additional formulas
#
%w{
  wget
  jq
  tree
  icu4c
}.each do |f|
  package f
end

#
# Install additional casks
#
%w{
  vagrant
  virtualbox
  bettertouchtool
  cyberduck
  dash
  kobito
}.each do |c|
  homebrew_cask c
end
