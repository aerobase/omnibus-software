# Copyright:: Copyright (c) 2015.
# License:: Apache License, Version 2.0
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

name "keycloak-server"
default_version "17.0.0"
skip_transitive_dependency_licensing true

version "17.0.0" do
  source md5: "0a020379838c897d8eea389ba1fb1b60"
end

source url: "https://github.com/keycloak/keycloak/releases/download/#{version}/keycloak-legacy-#{version}.tar.gz"

whitelist_file /libaio\.so\.1/
whitelist_file /\.*libartemis-native-64\.so/
whitelist_file /\.*libartemis-native-32\.so/

build do
  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak"
  sync "#{project_dir}/keycloak-#{version}/", "#{install_dir}/embedded/apps/keycloak-server/keycloak"

  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak/cli/"
end
