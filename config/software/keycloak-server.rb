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
default_version "9.0.3"
skip_transitive_dependency_licensing true

version "9.0.3" do
  source md5: "0b3c1968155f76c0540a0de8996b51e8"
end

source url: "https://downloads.jboss.org/keycloak/#{version}/keycloak-#{version}.tar.gz"

whitelist_file /libaio\.so\.1/
whitelist_file /\.*libartemis-native-64\.so/
whitelist_file /\.*libartemis-native-32\.so/

build do
  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak"
  sync "#{project_dir}/keycloak-#{version}/", "#{install_dir}/embedded/apps/keycloak-server/keycloak"

  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak/cli/"
end
