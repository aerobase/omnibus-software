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
default_version "3.4.3.Final"
skip_transitive_dependency_licensing true

dependency "wildfly"

version "3.4.3.Final" do
  source md5: "0c6c83827297208d39127342f44017ce"
end

version "3.4.2.Final" do
  source md5: "3878e44a310cb90782e330a445d45907"
end

source url: "https://downloads.jboss.org/keycloak/#{version}/keycloak-overlay-#{version}.tar.gz"

build do
  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak-overlay-#{version}"
  sync "#{project_dir}/", "#{install_dir}/embedded/apps/keycloak-server/keycloak-overlay-#{version}"

  # Strip KC version from packages.
  link "#{install_dir}/embedded/apps/keycloak-server/keycloak-overlay-#{version}", "#{install_dir}/embedded/apps/keycloak-server/keycloak-overlay"

  # install default-keycloak-subsys-config.cli to cli directory
  # update default-keycloak-subsys-config.cli.erb on KC version upgrade
  # keycloak-overlay-X-X-X.Final/modules/system/layers/keycloak/org/keycloak/keycloak-wildfly-server-subsystem/main/keycloak-wildfly-server-subsystem-3.4.3.Final.jar
  erb source: "default-keycloak-subsys-config.cli.erb",
      dest: "#{install_dir}/embedded/apps/keycloak-server/keycloak-overlay/cli",
      mode: 0755
end
