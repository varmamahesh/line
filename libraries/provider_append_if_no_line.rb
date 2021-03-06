#
# Cookbook Name:: line-dj
# Library:: provider_append_if_no_such_line
#
# Author:: Sean OMeara <someara@opscode.com>                                  
# Copyright 2012-2013, Opscode, Inc.
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

class Chef
  class Provider
    class AppendIfNoLine < Chef::Provider

      def load_current_resource
      end
      
      def action_edit             
        string = escape_string new_resource.line
        regex = /^#{string}$/


        if ::File.exists?(new_resource.path) then
          begin
            f = ::File.open(new_resource.path, "r+")
            
            found = false
            f.lines.each { |line| found = true if line =~ regex }
            
            if ! found then
              f.puts new_resource.line
              new_resource.updated_by_last_action(true)
            end
          ensure
            f.close
          end
        else
          begin
            f = ::File.open(new_resource.path, "w")
            f.puts new_resource.line
          ensure
            f.close
          end
        end
        
        
        def nothing
        end
        
      end
    end
  end
end
