ARG PACKAGES_IMAGE=cloudposse/packages:0.26.1
FROM ${PACKAGES_IMAGE} as packages

WORKDIR /packages

#
# Install the select packages from the cloudposse package manager image
#
# Repo: <https://github.com/cloudposse/packages>
#
ARG PACKAGES="aws-iam-authenticator awless cfssl cfssljson chamber fetch figurine gomplate goofys kubectl kops helm helmfile kubens sops stern terraform yq"
ENV PACKAGES=${PACKAGES}
ENV KUBECTL_VERSION=1.10.7
ENV HELMFILE_VERSION=0.37.0

RUN make -C /packages/install kubectl helmfile
RUN make dist
FROM nikiai/geodesic-base:debian

ENV BANNER "geodesic"

# Where to store state
ENV CACHE_PATH=/localhost/.geodesic

ENV GEODESIC_PATH=/usr/local/include/toolbox
ENV HOME=/conf
ENV SECRETS_PATH=${HOME}

WORKDIR /tmp

# Copy installer over to make package upgrades easy
COPY --from=packages /packages/install/ /packages/install/

# Copy select binary packages
COPY --from=packages /dist/ /usr/local/bin/

RUN kubectl completion bash > /etc/bash_completion.d/kubectl.sh
ADD "https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/terraform.completion.bash" /etc/bash_completion.d/terraform.bash

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
RUN helm repo add incubator  https://kubernetes-charts-incubator.storage.googleapis.com/ \
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

# Install aws cli bundle
#
ENV AWSCLI_VERSION=1.15.66
RUN pip install --no-cache-dir awscli==${AWSCLI_VERSION} && \
    rm -rf /root/.cache && \
    find / -type f -regex '.*\.py[co]' -delete && \
    ln -s /usr/local/aws/bin/aws_bash_completer /etc/bash_completion.d/aws.sh

#
# AWS
#
ENV AWS_DATA_PATH=/localhost/.aws/ \
    AWS_CONFIG_FILE=/localhost/.aws/config \
    AWS_SHARED_CREDENTIALS_FILE=/localhost/.aws/credentials

# Install awslogs bundle
#
RUN pip install --no-cache-dir awslogs && \
    rm -rf /root/.cache && \
    find / -type f -regex '.*\.py[co]' -delete

#
# Default kops configuration
#
ENV KOPS_CLUSTER_NAME=example.foo.bar \
    KOPS_STATE_STORE=s3://undefined \
    KOPS_STATE_STORE_REGION=ap-south-1 \
    KOPS_FEATURE_FLAGS=+DrainAndValidateRollingUpdate \
    KOPS_MANIFEST=/conf/kops/manifest.yaml \
    KOPS_TEMPLATE=/templates/kops/default.yaml \
    KOPS_BASE_IMAGE=coreos.com/CoreOS-stable-1800.0.0-hvm \
    KOPS_BASTION_PUBLIC_NAME="bastion" \
    KOPS_PRIVATE_SUBNETS="10.0.1.0/24,10.0.2.0/24,10.0.3.0/24" \
    KOPS_UTILITY_SUBNETS="10.0.101.0/24,10.0.102.0/24,10.0.103.0/24" \
    KOPS_AVAILABILITY_ZONES="ap-south-1a,ap-south-1b" \
    BASTION_MACHINE_TYPE="t2.nano" \
    MASTER_MACHINE_TYPE="t2.medium"

COPY rootfs/ /

WORKDIR /conf

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "bootstrap"]
