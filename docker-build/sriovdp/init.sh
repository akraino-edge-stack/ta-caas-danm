#!/bin/sh
# Copyright 2019 Nokia
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

while true; do
  date
  err=0

  rootdevs=`jq -r .resourceList[].rootDevices[] </etc/pcidp/config.json 2>/dev/null`
  if [[ -n "$rootdevs" ]]; then
    for pci in $rootdevs; do
      vf=`cat /sys/bus/pci/devices/$pci/sriov_numvfs`
      echo "$pci: $vf VFs"
      if [[ -z "$vf" || "$vf" == "0" ]]; then
        echo "No VFs found -> SR-IOV DP cannot be started"
        err=1
      fi
    done
  else
    echo "No SR-IOV designated PF found -> SR-IOV DP cannot be started"
    err=1
  fi

  if [ $err -eq 0 ]; then
    exit 0
  else
    echo "Error happened -> sleep 10 -> retry"
    sleep 10
  fi
done
