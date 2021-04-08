#
# Copyright:: Chef Software, Inc.
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

name "git"
default_version "2.9.5"

license "LGPL-2.1"
license_file "LGPL-2.1"
skip_transitive_dependency_licensing true

dependency "curl"
dependency "zlib"
dependency "openssl"
dependency "pcre"
dependency "libiconv" # FIXME: can we figure out how to remove this?
dependency "expat"

relative_path "git-#{version}"

# version_list: url=https://www.kernel.org/pub/software/scm/git/ filter=*.tar.gz
version("2.9.5") { source sha256: "8fa575338137d6d850b52d207cf7155cd1f4003ebd698f0fb75f65efb862ef7f" }
version("2.8.6") { source sha256: "56ff3fa922946e4db0f568ad7390feac332c1c747299a1dc9d2f7d2c88857a46" }
version("2.7.6") { source sha256: "ce98ac8d823d8015ed863e28b47f38d3926e6f6228090ad90348c58d98ec892a" }
version("2.6.7") { source sha256: "a36577fb94ddfbcb8cbe74c9f4bcdb5c2e36768a32ccebbcd2f173469d95ec3c" }
version("2.5.6") { source sha256: "905150c5b887cc4f29fcf3eafedd340d0a69eb6ac8064d41627f1b1a894e260f" }
version("2.4.9") { source sha256: "49024089b2f7b398164072e22a845e7987c9c4043c7bf19778af2ef2b2c285ac" }
version("2.31.1") { source sha256: "46d37c229e9d786510e0c53b60065704ce92d5aedc16f2c5111e3ed35093bfa7" }
version("2.30.2") { source sha256: "9ddea08fc7c38f1823a54a014ae2e9ecd45e1b4a06e919025f4c41f2c6a8061b" }
version("2.3.9") { source sha256: "5f98f3700045d9786c51c32004ba86984d2af5cfa96df6ebe07188060ea68826" }
version("2.29.3") { source sha256: "dfaa7608c67fa84483c09fdbea1367848d56b050ed200e541a9829701d45ccad" }
version("2.29.2") { source sha256: "869a121e1d75e4c28213df03d204156a17f02fce2dc77be9795b327830f54195" }
version("2.28.0") { source sha256: "f914c60a874d466c1e18467c864a910dd4ea22281ba6d4d58077cb0c3f115170" }
version("2.26.2") { source sha256: "e1c17777528f55696815ef33587b1d20f5eec246669f3b839d15dbfffad9c121" }

source url: "https://www.kernel.org/pub/software/scm/git/git-#{version}.tar.gz"

# git builds git-core as binaries into a special directory. We need to include
# that directory in bin_dirs so omnibus can sign them during macOS deep signing.
bin_dirs bin_dirs.concat ["#{install_dir}/embedded/libexec/git-core"]

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # We do a distclean so we ensure that the autoconf files are not trying to be
  # clever.
  make "distclean"

  # In 2.13.1 they introduced some sha code that wasn't super good at endianness
  if aix?
    # AIX needs /opt/freeware/bin only for patch
    patch_env = env.dup
    patch_env["PATH"] = "/opt/freeware/bin:#{env["PATH"]}"

    patch source: "aix-endian-fix.patch", plevel: 0, env: patch_env
  end

  config_hash = {
    # Universal options
    NO_GETTEXT: "YesPlease",
    NEEDS_LIBICONV: "YesPlease",
    NO_INSTALL_HARDLINKS: "YesPlease",
    NO_PERL: "YesPlease",
    NO_PYTHON: "YesPlease",
    NO_TCLTK: "YesPlease",
  }

  if freebsd?
    config_hash["CHARSET_LIB"] = "-lcharset"
    config_hash["FREAD_READS_DIRECTORIES"] = "UnfortunatelyYes"
    config_hash["HAVE_CLOCK_GETTIME"] = "YesPlease"
    config_hash["HAVE_CLOCK_MONOTONIC"] = "YesPlease"
    config_hash["HAVE_GETDELIM"] = "YesPlease"
    config_hash["HAVE_PATHS_H"] = "YesPlease"
    config_hash["HAVE_STRINGS_H"] = "YesPlease"
    config_hash["PTHREAD_LIBS"] = "-pthread"
    config_hash["USE_ST_TIMESPEC"] = "YesPlease"
    config_hash["HAVE_BSD_SYSCTL"] = "YesPlease"
    config_hash["NO_R_TO_GCC_LINKER"] = "YesPlease"
  elsif aix?
    env["CC"] = "xlc_r"
    env["INSTALL"] = "/opt/freeware/bin/install"
    env["CFLAGS"] = "-q64 -qmaxmem=-1 -I#{install_dir}/embedded/include -D_LARGE_FILES -O2"
    env["CPPFLAGS"] = "-q64 -qmaxmem=-1 -I#{install_dir}/embedded/include -D_LARGE_FILES -O2"
    env["LDFLAGS"] = "-q64 -L#{install_dir}/embedded/lib -lcurl -lssl -lcrypto -lz -Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib"
    # xlc doesn't understand the '-Wl,-rpath' syntax at all so... we don't enable
    # the NO_R_TO_GCC_LINKER flag. This means that it will try to use the
    # old style -R for libraries and as a result, xlc will ignore it. In this case, we
    # we want that to happen because we explicitly set the libpath with the correct
    # command line argument in omnibus itself.
    config_hash["CC_LD_DYNPATH"] = "-R"
    config_hash["AR"] = "ar -X64"
    config_hash["NO_REGEX"] = "YesPlease"
  else
    # Linux things!
    config_hash["HAVE_PATHS_H"] = "YesPlease"
    config_hash["NO_R_TO_GCC_LINKER"] = "YesPlease"
  end

  # ensure that header files in git's source code are found first before looking in other directories
  # this solves an issue that occurs when libarchive has been built and installed and its archive.h header
  # file in #{install_dir}/embedded/include is accidentally picked up when compiling git
  env["CFLAGS"] = "-I. #{env["CFLAGS"]}"
  env["CPPFLAGS"] = "-I. #{env["CPPFLAGS"]}"
  env["CXXFLAGS"] = "-I. #{env["CXXFLAGS"]}"

  erb source: "config.mak.erb",
      dest: "#{project_dir}/config.mak",
      mode: 0755,
      vars: {
               cc: env["CC"],
               ld: env["LD"],
               cflags: env["CFLAGS"],
               cppflags: env["CPPFLAGS"],
               install: env["INSTALL"],
               install_dir: install_dir,
               ldflags: env["LDFLAGS"],
               shell_path: env["SHELL_PATH"],
               config_hash: config_hash,
             }

  # NOTE - If you run ./configure the environment variables set above will not be
  # used and only the command line args will be used. The issue with this is you
  # cannot specify everything on the command line that you can with the env vars.
  make "prefix=#{install_dir}/embedded -j #{workers}", env: env
  make "prefix=#{install_dir}/embedded install", env: env
end
