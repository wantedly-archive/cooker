#
# Author:: Seigo Uchida (<spesnova@gmail.com>)
# Cookbook Name:: default
# Attributes:: default
#
# Copyright (C) 2013 Seigo Uchida (<spesnova@gmail.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default["rbenv"]["create_profiled"] = false
default["rbenv"]["root_path"] = File.join(ENV["HOME"], ".rbenv")
default["rbenv"]["user_installs"] = [
  {
    "user"   => node["current_user"],
    "rubies" => ["2.0.0-p247"],
    "global" => "2.0.0-p247",
    "gems"   => {
      "2.0.0-p247" => [
        { "name"   => "bundler" }
      ]
    }
  }
]
