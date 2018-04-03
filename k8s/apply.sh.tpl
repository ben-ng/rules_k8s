#!/bin/bash

# Copyright 2017 The Bazel Authors. All rights reserved.
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
set -euo pipefail

function guess_runfiles() {
    pushd ${BASH_SOURCE[0]}.runfiles > /dev/null 2>&1
    pwd
    popd > /dev/null 2>&1
}

set -x
RUNFILES="${PYTHON_RUNFILES:-$(guess_runfiles)}"

2>&1 echo "KUBECONFIG=${KUBECONFIG}"
2>&1 ls -l "${KUBECONFIG}"
2>&1 kubectl config view
PYTHON_RUNFILES=${RUNFILES} %{resolve_script} | \
  KUBECONFIG="${KUBECONFIG}" kubectl --cluster="%{cluster}" %{namespace_arg} apply -f -
