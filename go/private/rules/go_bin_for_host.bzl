# Copyright 2023 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@local_config_platform//:constraints.bzl", "HOST_CONSTRAINTS")
load("//go/private:go_toolchain.bzl", "GO_TOOLCHAIN")

def _go_bin_for_host_impl(ctx):
    """Exposes the go binary of the current Go toolchain for the host."""
    sdk = ctx.toolchains[GO_TOOLCHAIN].sdk
    sdk_files = ctx.runfiles([sdk.go] + sdk.headers + sdk.libs + sdk.srcs + sdk.tools)

    return [
        DefaultInfo(
            files = depset([sdk.go]),
            runfiles = sdk_files,
        ),
    ]

go_bin_for_host = rule(
    implementation = _go_bin_for_host_impl,
    toolchains = [GO_TOOLCHAIN],
    # Resolve a toolchain that runs on the host platform.
    exec_compatible_with = HOST_CONSTRAINTS,
)
