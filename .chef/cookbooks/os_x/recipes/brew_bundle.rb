# Cookbook Name:: os_x
# Recipe:: brew_bundle
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
# Install Formulas
#
node["homebrew"]["formulas"].each do |f|
  package f do
    action :install
  end
end

#
# Install Casks
#
if node["homebrew"]["enable_cask"]
  homebrew_tap 'caskroom/cask'
  package "brew-cask"

  directory "/opt/homebrew-cask" do
    user node["rbenv"]["user"]
    group node["rbenv"]["user"]
  end

  directory "/opt/homebrew-cask/Caskroom" do
    user node["rbenv"]["user"]
    group node["rbenv"]["user"]
  end

  node["homebrew"]["casks"].each do |c|
    homebrew_cask c do
      action :cask
    end
  end
end
