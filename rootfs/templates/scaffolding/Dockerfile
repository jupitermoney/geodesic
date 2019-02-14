FROM {{ getenv "GEODESIC_IMAGE" "cloudposse/geodesic" }}:{{ getenv "GEODESIC_TAG" "latest" }}

ENV DOCKER_IMAGE "{{ getenv "DOCKER_IMAGE" "org/geodesic.example.org" }}"
ENV DOCKER_TAG "{{ getenv "DOCKER_TAG" "latest" }}"

# Default AWS Profile name
ENV AWS_DEFAULT_PROFILE="{{ getenv "AWS_DEFAULT_PROFILE" "ops" }}"

# AWS Region for the cluster
ENV AWS_REGION="{{ getenv "AWS_REGION" "us-west-2"}}"

# Kubernetes Node EC2 instance type (optional, required if the cluster uses Kubernetes)
ENV NODE_MACHINE_TYPE "{{ getenv "NODE_MACHINE_TYPE" "m5.large" }}"

# Kubernetes node count (Node EC2 instance count) (optional, required if the cluster uses Kubernetes)
ENV NODE_MAX_SIZE "{{ getenv "NODE_MAX_SIZE" "2" }}"
ENV NODE_MIN_SIZE "{{ getenv "NODE_MIN_SIZE" "2" }}"

# Terraform
ENV TF_BUCKET ""
ENV TF_BUCKET_REGION "${AWS_REGION}"
ENV TF_DYNAMODB_TABLE ""

# Place configuration in 'conf/' directory
COPY conf/ /conf/

WORKDIR /conf/