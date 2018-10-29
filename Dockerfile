#
# Cloud Posse Package Distribution
#
FROM cloudposse/packages:0.42.0 as packages

WORKDIR /packages

#
# Install the select packages from the cloudposse package manager image
#
# Repo: <https://github.com/cloudposse/packages>
#
ARG PACKAGES="aws-iam-authenticator awless cfssl cfssljson chamber fetch figurine gomplate goofys helm helmfile kops kubectl kubens sops stern terraform yq"
ENV PACKAGES=${PACKAGES}
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

ENV KOPS_STATE_STORE_REGION=ap-south-1 \
    KOPS_FEATURE_FLAGS=+DrainAndValidateRollingUpdate \
    KOPS_MANIFEST=/conf/kops/manifest.yaml \
    KOPS_TEMPLATE=/templates/kops/default.yaml \
    KOPS_BASE_IMAGE=coreos.com/CoreOS-stable-1800.0.0-hvm \
    KOPS_BASTION_PUBLIC_NAME="bastion" \
    KOPS_PRIVATE_SUBNETS="10.0.1.0/24,10.0.2.0/24,10.0.3.0/24" \
    KOPS_UTILITY_SUBNETS="10.0.101.0/24,10.0.102.0/24,10.0.103.0/24" \
    KOPS_AVAILABILITY_ZONES="ap-south-1a,ap-south-1b" \
    BASTION_MACHINE_TYPE="t2.nano"

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
ENV HELM_DIFF_VERSION 2.11.0+2
ENV HELM_EDIT_VERSION 0.2.0
ENV HELM_S3_VERSION 0.7.0

RUN helm plugin install https://github.com/app-registry/appr-helm-plugin --version v${HELM_APPR_VERSION} \
    && helm plugin install https://github.com/databus23/helm-diff --version v${HELM_DIFF_VERSION} \
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
