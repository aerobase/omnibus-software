#
# Copyright 2012-2016 Chef Software, Inc.
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
## expeditor/ignore: deprecated 2022 03

name "nginx"
default_version "1.21.4"

dependency "pcre"
dependency "openssl"
dependency "zlib"

license "BSD-2-Clause"
license_file "LICENSE"

source url: "https://nginx.org/download/nginx-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

# versions_list: https://nginx.org/download/ filter=*.tar.gz
version("1.21.4") { source sha256: "d1f72f474e71bcaaf465dcc7e6f7b6a4705e4b1ed95c581af31df697551f3bfe" }
version("1.20.1") { source sha256: "e462e11533d5c30baa05df7652160ff5979591d291736cfa5edb9fd2edb48c49" }
version("1.19.9") { source sha256: "2e35dff06a9826e8aca940e9e8be46b7e4b12c19a48d55bfc2dc28fc9cc7d841" }
version("1.19.8") { source sha256: "308919b1a1359315a8066578472f998f14cb32af8de605a3743acca834348b05" }
version("1.16.1") { source sha256: "f11c2a6dd1d3515736f0324857957db2de98be862461b5a542a3ac6188dbe32b" }
version("1.18.0") { source sha256: "4c373e7ab5bf91d34a4f11a0c9496561061ba5eee6020db272a17a7228d35f99" }
version("1.14.2") { source sha256: "002d9f6154e331886a2dd4e6065863c9c1cf8291ae97a1255308572c02be9797" }
version("1.14.0") { source sha256: "5d15becbf69aba1fe33f8d416d97edd95ea8919ea9ac519eff9bafebb6022cb5" }
version("1.12.2") { source sha256: "305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324cf0416" }
version("1.10.2") { source md5: "e8f5f4beed041e63eb97f9f4f55f3085" }
version("1.9.1") { source md5: "fc054d51effa7c80a2e143bc4e2ae6a7" }
version("1.8.1") { source md5: "2e91695074dbdfbf1bcec0ada9fda462" }
version("1.8.0") { source md5: "3ca4a37931e9fa301964b8ce889da8cb" }
version("1.6.3") { source md5: "ea813aee2c344c2f5b66cdb24a472738" }
version("1.4.7") { source md5: "aee151d298dcbfeb88b3f7dd3e7a4d17" }
version("1.4.4") { source md5: "5dfaba1cbeae9087f3949860a02caa9f" }
>>>>>>> Upgrade to nginx 16.1

relative_path "nginx-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --with-http_ssl_module" \
          " --with-http_stub_status_module" \
          " --with-ipv6" \
          " --with-debug" \
          " --with-http_realip_module" \
          " --with-http_sub_module" \
          " --with-http_mp4_module" \
          " --with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\"" \
          " --with-ld-opt=-L#{install_dir}/embedded/lib", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # Ensure the logs directory is available on rebuild from git cache
  touch "#{install_dir}/embedded/logs/.gitkeep"
end
