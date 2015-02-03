#
# Cookbook Name:: default
# Recipe:: default
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

bash "insert_line_rbenvpath" do
  environment "HOME"
  code <<-EOS
    echo "
      function _rails_command () {
        if [ -e "bin/rails" ]; then
          bin/rails $@
        elif [ -e "script/rails" ]; then
          ruby script/rails $@
        elif [ -e "script/server" ]; then
          ruby script/$@
        else
          command rails $@
        fi
      }

      function _rake_command () {
        if [ -e "bin/rake" ]; then
          bin/rake $@
        else
          command rake $@
        fi
      }

      alias rails='_rails_command'
      compdef _rails_command=rails

      alias rake='_rake_command'
      compdef _rake_command=rake

    " >> ~/.#{ENV["SHELL"]}rc
    exec $SHELL
  EOS
end
