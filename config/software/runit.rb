#
# Copyright 2012-2014 Chef Software, Inc.
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

name "runit"
default_version "2.1.2"

license "BSD-3-Clause"
license_file "../package/COPYING"
skip_transitive_dependency_licensing true

# version_list: url=http://smarden.org/runit/ filter=*.tar.gz

version("2.1.2") { source sha256: "6fd0160cb0cf1207de4e66754b6d39750cff14bb0aa66ab49490992c0c47ba18" }
version("2.1.1") { source sha256: "ffcf2d27b32f59ac14f2d4b0772a3eb80d9342685a2042b7fbbc472c07cf2a2c" }

source url: "http://smarden.org/runit/runit-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
relative_path "admin/runit-#{version}/src"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # GCC 14+ (CentOS Stream 10, Fedora 40+) treats implicit function declarations
  # and incompatible pointer types as errors. Runit's old C code triggers both.
  # Downgrade to warnings so the legacy source compiles and configure detects
  # POSIX features (waitpid, sigaction, sigprocmask) correctly.
  env["CFLAGS"] << " -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types"

  runit_patch = File.expand_path("../patches/runit/runit-2.1.2-modern-setgroups.patch", __dir__)

  # Newer glibc toolchains require the setgroups prototype and reject raw int pointers.
  command "git apply #{runit_patch}", env: env

  # Put runit where we want it, not where they tell us to
  command 'sed -i -e "s/^char\ \*varservice\ \=\"\/service\/\";$/char\ \*varservice\ \=\"' + install_dir.gsub("/", "\\/") + '\/service\/\";/" sv.c', env: env

  # TODO: the following is not idempotent
  command "sed -i -e s:-static:: Makefile", env: env

  # Build it
  make env: env
  make "check", env: env

  # Move it
  mkdir "#{install_dir}/embedded/bin"
  copy "#{project_dir}/chpst",      "#{install_dir}/embedded/bin"
  copy "#{project_dir}/runit",      "#{install_dir}/embedded/bin"
  copy "#{project_dir}/runit-init", "#{install_dir}/embedded/bin"
  copy "#{project_dir}/runsv",      "#{install_dir}/embedded/bin"
  copy "#{project_dir}/runsvchdir", "#{install_dir}/embedded/bin"
  copy "#{project_dir}/runsvdir",   "#{install_dir}/embedded/bin"
  copy "#{project_dir}/sv",         "#{install_dir}/embedded/bin"
  copy "#{project_dir}/svlogd",     "#{install_dir}/embedded/bin"
  copy "#{project_dir}/utmpset",    "#{install_dir}/embedded/bin"

  erb source: "runsvdir-start.erb",
      dest: "#{install_dir}/embedded/bin/runsvdir-start",
      mode: 0755,
      vars: { install_dir: install_dir }

  # Setup service directories
  touch "#{install_dir}/service/.gitkeep"
  touch "#{install_dir}/sv/.gitkeep"
  touch "#{install_dir}/init/.gitkeep"
end
