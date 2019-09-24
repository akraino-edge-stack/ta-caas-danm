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

ARG go_version
FROM golang:${go_version}-alpine3.9 as builder
MAINTAINER Ferenc Toth <ferenc.2.toth@nokia.com>

ARG SRIOVDP
ARG SRIOVDP_HASH=""

RUN apk add --no-cache gcc musl-dev git curl tar linux-headers \
&& mkdir -p $GOPATH/src/github.com/intel/sriov-network-device-plugin \
&& cd $GOPATH/src/github.com/intel \
&& if [ -n "$SRIOVDP_HASH" ]; then \
     git clone https://github.com/intel/sriov-network-device-plugin.git \
&&   cd sriov-network-device-plugin \
&&   git checkout $SRIOVDP_HASH; \
   else \
     curl -fsSL https://github.com/intel/sriov-network-device-plugin/archive/v${SRIOVDP}.tar.gz | tar xz --strip-components=1 -C sriov-network-device-plugin; \
   fi \
&& go install -a -ldflags '-extldflags "-static"' github.com/intel/sriov-network-device-plugin/cmd/sriovdp

FROM alpine:3.9
RUN apk add --no-cache hwdata-pci jq

COPY --from=builder /go/bin/sriovdp /usr/local/bin/
RUN chmod 700 /usr/local/bin/sriovdp

WORKDIR /
LABEL io.k8s.display-name="SRIOV Network Device Plugin"
ENTRYPOINT ["/usr/local/bin/sriovdp"]
