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
default_version "7.0.1"
skip_transitive_dependency_licensing true

dependency "wildfly"

version "7.0.1" do
  source md5: "effadaeb7c52659ae48da51593fbc59a"
end

version "4.8.3.Final" do
  source md5: "48b3bba325550ce57eff74d43ef867fd"
end

version "4.8.1.Final" do
  source md5: "05b3236e9e0c4293b4e496e77d63ec28"
end

version "4.7.0.Final" do
  source md5: "588035466fcd65d8593d4a57d73ff796"
end

version "4.6.0.Final" do
  source md5: "5e12374673b2b61c7ae96691bae2c0cc"
end

version "4.5.0.Final" do
  source md5: "d6ab41cc8a147ef9e2ceb75e613df854"
end

version "4.3.0.Final" do
  source md5: "49cd673631f15d55f7250f103b8b250f"
end

version "3.4.3.Final" do
  source md5: "0c6c83827297208d39127342f44017ce"
end

version "3.4.2.Final" do
  source md5: "3878e44a310cb90782e330a445d45907"
end

source url: "https://downloads.jboss.org/keycloak/#{version}/keycloak-overlay-#{version}.tar.gz"

build do
  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak-overlay"
  sync "#{project_dir}/", "#{install_dir}/embedded/apps/keycloak-server/keycloak-overlay"

  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak-overlay/cli/"
end
