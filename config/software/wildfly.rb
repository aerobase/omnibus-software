#
# Copyright:: Copyright (c) 2015.
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

name "wildfly"
default_version "11.0.0.Final"
skip_transitive_dependency_licensing true

version "13.0.0.Final" do
  source md5: "8944455abcbe8ca185ed2ef36a02aa04"
end

version "11.0.0.Final" do
  source md5: "c68224ce162371a1aa7890f847cebca5"
end

source url: "http://download.jboss.org/wildfly/#{version}/wildfly-#{version}.tar.gz"

relative_path "wildfly-#{version}"

whitelist_file /libaio\.so\.1/
whitelist_file /\.*libartemis-native-64\.so/

build do
  env = with_standard_compiler_flags

  command "mkdir -p #{install_dir}/embedded/apps/wildfly"
  sync "./", "#{install_dir}/embedded/apps/wildfly"
end
