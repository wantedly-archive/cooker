# Cookbook Name:: os_x
# Recipe:: ruby
#
# Copyright (C) 2014 Seigo Uchida
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Install rbenv, ruby-build via homebrew
#
package "rbenv"
package "ruby-build"
package "rbenv-gem-rehash"

#
# Create rbenv root
#
directory node["rbenv"]["root"] do
  owner node["current_user"]
  group "staff"
  recursive true
end

#
# Install Rubies
#
node["rbenv"]["rubies"].each do |version|
  execute "Install ruby#{version}" do
    command "/usr/local/bin/rbenv install #{version}"
    user node["rbenv"]["user"]
    group node["rbenv"]["group"]
    environment({ "RBENV_ROOT" => node["rbenv"]["root"] })
    not_if { ::File.exists?("#{node['rbenv']['root']}/versions/#{version}") }
  end
end

#
# Install Gems
#
path = [
  "#{node['rbenv']['root']}/shims",
  "#{node['rbenv']['root']}/bin",
  ENV['PATH'].chomp.split(':'),
].flatten.join(':')

node["rbenv"]["gems"].each do |version, gems|
  gems.each do |gem|
    version_option = gem['version'].nil? ? "" : " -v #{gem['version']}"

    execute "Install #{gem['name']} to ruby#{version}" do
      command "#{node['rbenv']['root']}/shims/gem install #{gem['name']} --no-ri --no-rdoc -q #{version_option}"
      user node["rbenv"]["user"]
      group node["rbenv"]["group"]
      environment({
        "RBENV_ROOT"    => node["rbenv"]["root"],
        "RBENV_VERSION" => version,
        "PATH"          => path
      })
      not_if { %x( #{node['rbenv']['root']}/shims/gem list -i #{gem['name']} #{version_option} ).chomp == "true" }
    end
  end
end

#
# Set Global Version
#
file "#{node['rbenv']['root']}/version" do
  user node["rbenv"]["user"]
  group node["rbenv"]["group"]
  content node['rbenv']['global']
end

execute "Set #{node['rbenv']['global']} to global ruby version" do
  command "/usr/local/bin/rbenv global #{node['rbenv']['global']}"
  user node["rbenv"]["user"]
  group node["rbenv"]["group"]
  environment({ "RBENV_ROOT" => node["rbenv"]["root"] })
  not_if { ::File.open("#{node['rbenv']['root']}/version").read.chomp == node["rbenv"]["global"] }
end
