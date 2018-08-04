ARG PACKAGES_IMAGE=cloudposse/packages:0.3.1
FROM ${PACKAGES_IMAGE} as packages
WORKDIR /packages

# 
# Install the select packages from the cloudposse package manager image
#
# Repo: <https://github.com/cloudposse/packages>
#

ARG PACKAGES="awless cfssl cfssljson chamber fetch github-commenter gomplate goofys helm helmfile kubens sops terraform yq"
ENV PACKAGES=${PACKAGES}
RUN make dist

FROM nikiai/geodesic-base:debian

ENV BANNER "geodesic"

ENV GEODESIC_PATH=/usr/local/include/toolbox
ENV HOME=/conf
ENV SECRETS_PATH=${HOME}

WORKDIR /tmp

# Copy installer over to make package upgrades easy
COPY --from=packages /packages/install/ /packages/install/

# Copy select binary packages
COPY --from=packages /dist/ /usr/local/bin/

#
# Install kubeaws
#
ENV KOPS_VERSION=1.10.0-beta.1
RUN curl --fail -sSL -O https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64\
    && mv kops-linux-amd64 /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops \
    && /usr/local/bin/kops completion bash > /etc/profile.d/kops.sh \
    && chmod 755 /etc/profile.d/kops.sh

#
# Install kubectl
#
ENV KUBECTL_VERSION=1.10.3
RUN curl --fail -sSL -O https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && kubectl completion bash > /etc/bash_completion.d/kubectl.sh

#
# Install heptio
#
ENV HEPTIO_VERSION=1.10.3
RUN curl --fail -sSL -O https://amazon-eks.s3-us-west-2.amazonaws.com/${HEPTIO_VERSION}/2018-06-05/bin/linux/amd64/heptio-authenticator-aws \
    && mv heptio-authenticator-aws /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator

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
ENV HELM_GITHUB_VERSION 0.2.0
ENV HELM_SECRETS_VERSION 1.2.9

RUN helm plugin install https://github.com/app-registry/appr-helm-plugin --version v${HELM_APPR_VERSION} \
    && helm plugin install https://github.com/mstrzele/helm-edit --version v${HELM_EDIT_VERSION} \
    && helm plugin install https://github.com/futuresimple/helm-secrets --version ${HELM_SECRETS_VERSION} \
    && helm plugin install https://github.com/sagansystems/helm-github --version ${HELM_GITHUB_VERSION}


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

ADD "https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/terraform.completion.bash" /etc/bash_completion.d/terraform.bash
#
# Default kops configuration
#
ENV KOPS_CLUSTER_NAME=example.foo.bar \
    KOPS_STATE_STORE=s3://undefined \
    KOPS_STATE_STORE_REGION=ap-south-1 \
    KOPS_FEATURE_FLAGS=+DrainAndValidateRollingUpdate \
    KOPS_MANIFEST=/conf/kops/manifest.yaml \
    KOPS_TEMPLATE=/templates/kops/default.yaml \
    KOPS_BASE_IMAGE=coreos.com/CoreOS-stable-1745.7.0-hvm \
    KOPS_BASTION_PUBLIC_NAME="bastion" \
    KOPS_PRIVATE_SUBNETS="10.0.1.0/24,10.0.2.0/24,10.0.3.0/24" \
    KOPS_UTILITY_SUBNETS="10.0.101.0/24,10.0.102.0/24,10.0.103.0/24" \
    KOPS_AVAILABILITY_ZONES="us-west-2a,us-west-2b,us-west-2c" \
    BASTION_MACHINE_TYPE="t2.medium" \
    MASTER_MACHINE_TYPE="t2.medium" \
    NODE_MACHINE_TYPE="t2.medium" \
    NODE_MAX_SIZE=2 \
    NODE_MIN_SIZE=2


COPY rootfs/ /

WORKDIR /conf

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "bootstrap"]
