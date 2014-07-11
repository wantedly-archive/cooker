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
  execute "Install ruby #{version}" do
    user node["rbenv"]["user"]
    group node["rbenv"]["group"]
    environment({ "RBENV_ROOT" => node["rbenv"]["root"] })
    command "/usr/local/bin/rbenv install #{version}"
    not_if { ::File.exists?("#{node['rbenv']['root']}/versions/#{version}") }
  end
end
