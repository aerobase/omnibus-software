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

default_version "23.0.7"
skip_transitive_dependency_licensing true

version "23.0.6" do
  source md5: "e4448370729753d82a480c8c58073786"
end

version "23.0.7" do
  source md5: "6ac7d0f3b06ec7e95601cc8d3fc095fb"
end

source url: "https://github.com/keycloak/keycloak/releases/download/#{version}/keycloak-#{version}.tar.gz"

build do
  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak"
  sync "#{project_dir}/keycloak-#{version}/", "#{install_dir}/embedded/apps/keycloak-server/keycloak"

  command "mkdir -p #{install_dir}/embedded/apps/keycloak-server/keycloak/cli/"
end
