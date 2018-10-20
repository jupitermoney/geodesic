#
# Cloud Posse Package Distribution
#
FROM cloudposse/packages:0.40.0 as packages

WORKDIR /packages

#
# Install the select packages from the cloudposse package manager image
#
# Repo: <https://github.com/cloudposse/packages>
#
ARG PACKAGES="aws-iam-authenticator awless cfssl cfssljson chamber fetch figurine gomplate goofys helm helmfile kops kubectl kubens sops stern terraform yq"
ENV PACKAGES=${PACKAGES}
ENV KOPS_VERSION=1.11.0-alpha.1
RUN make -C /packages/install kops
RUN make dist


#
# Geodesic base image
#
FROM nikiai/geodesic-base:debian

ENV BANNER "geodesic"

# Where to store state
ENV CACHE_PATH=/localhost/.geodesic

ENV GEODESIC_PATH=/usr/local/include/toolbox
ENV HOME=/conf
ENV KOPS_CLUSTER_NAME=example.foo.bar

#
# Python Dependencies
#
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy installer over to make package upgrades easy
COPY --from=packages /packages/install/ /packages/install/

# Copy select binary packages
COPY --from=packages /dist/ /usr/local/bin/

#
# Install kubectl
#
ENV KUBERNETES_VERSION 1.10.8
ENV KUBECONFIG=${SECRETS_PATH}/kubernetes/kubeconfig
RUN kubectl completion bash > /etc/bash_completion.d/kubectl.sh

#
# Install kops
#
ENV KOPS_STATE_STORE s3://undefined
ENV KOPS_STATE_STORE_REGION us-east-1
ENV KOPS_FEATURE_FLAGS=+DrainAndValidateRollingUpdate
ENV KOPS_MANIFEST=/conf/kops/manifest.yaml
ENV KOPS_TEMPLATE=/templates/kops/default.yaml

# https://github.com/kubernetes/kops/blob/master/channels/stable
# https://github.com/kubernetes/kops/blob/master/docs/images.md
ENV KOPS_BASE_IMAGE=kope.io/k8s-1.9-debian-jessie-amd64-hvm-ebs-2018-03-11

ENV KOPS_BASTION_PUBLIC_NAME="bastion"
ENV KOPS_PRIVATE_SUBNETS="172.20.32.0/19,172.20.64.0/19,172.20.96.0/19,172.20.128.0/19"
ENV KOPS_UTILITY_SUBNETS="172.20.0.0/22,172.20.4.0/22,172.20.8.0/22,172.20.12.0/22"
ENV KOPS_AVAILABILITY_ZONES="us-west-2a,us-west-2b,us-west-2c"
ENV KUBECONFIG=/dev/shm/kubecfg
RUN /usr/local/bin/kops completion bash > /etc/bash_completion.d/kops.sh

# Instance sizes
ENV BASTION_MACHINE_TYPE "t2.medium"
ENV MASTER_MACHINE_TYPE "t2.medium"
ENV NODE_MACHINE_TYPE "t2.medium"

# Min/Max number of nodes (aka workers)
ENV NODE_MAX_SIZE 2
ENV NODE_MIN_SIZE 2

#
# Install helm
#
ENV HELM_HOME /var/lib/helm
ENV HELM_VALUES_PATH=${SECRETS_PATH}/helm/values
RUN helm completion bash > /etc/bash_completion.d/helm.sh \
    && mkdir -p ${HELM_HOME} \
    && helm init --client-only \
    && mkdir -p ${HELM_HOME}/plugins

#
# Install helm repos
#
RUN helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/ \
    && helm repo add incubator  https://kubernetes-charts-incubator.storage.googleapis.com/ \
    && helm repo add coreos-stable https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/ \
    && helm repo update

#
# Install helm plugins
#
ENV HELM_APPR_VERSION 0.7.0
ENV HELM_EDIT_VERSION 0.2.0
ENV HELM_S3_VERSION 0.7.0

RUN helm plugin install https://github.com/app-registry/appr-helm-plugin --version v${HELM_APPR_VERSION} \
    && helm plugin install https://github.com/mstrzele/helm-edit --version v${HELM_EDIT_VERSION} \
    && helm plugin install https://github.com/hypnoglow/helm-s3 --version v${HELM_S3_VERSION}

#
# AWS
#
ENV AWS_DATA_PATH=/localhost/.aws/
ENV AWS_CONFIG_FILE=/localhost/.aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/localhost/.aws/credentials

#
# Shell
#
ENV HISTFILE=${CACHE_PATH}/history
ENV SHELL=/bin/bash
ENV LESS=-Xr
ENV XDG_CONFIG_HOME=${CACHE_PATH}
ENV SSH_AGENT_CONFIG=/var/tmp/.ssh-agent

COPY rootfs/ /

WORKDIR /conf

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "bootstrap"]
