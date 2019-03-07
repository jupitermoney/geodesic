# Automatically export the current environment to `TF_VAR`
# Use a regex defined in the `TFENV_WHITELIST` and `TFENV_BLACKLIST` environment variables to include and exclude variables
#source <(tfenv)
export TF_VAR_namespace="niki"
export TF_VAR_region="${AWS_REGION}"
export TF_VAR_account_id="${AWS_ACCOUNT_ID}"
export TF_BUCKET_REGION="${AWS_REGION}"
export TF_VAR_gitlab_token="${GITLAB_ACCESS_TOKEN}"
export TF_CLI_PLAN_PARALLELISM=2
export MAKE_INCLUDES="Makefile Makefile.*"
export TF_VAR_parent_domain_name="niki.ai"
export TF_VAR_stage="${STAGE}"
export TF_VAR_domain_name="${TF_VAR_stage}.niki.ai"
export TF_VAR_aws_assume_role_arn="arn:aws:iam::${TF_VAR_account_id}:role/${ASSUME_ROLE}"
export TF_DYNAMODB_TABLE="${TF_VAR_namespace}-${TF_VAR_stage}-terraform-state-lock"
export TF_BUCKET="${TF_VAR_namespace}-${TF_VAR_stage}-terraform-state"

# Filesystem entry for tfstate
s3 fstab "${TF_BUCKET}" "/" "/secrets/tf"

isMounted() { findmnt -rno SOURCE,TARGET "$1" >/dev/null;}
if isMounted "/secrets/tf";
   then echo "already mounted in another shell"
   else s3 mount
fi
export KUBECONFIG=$(echo "/conf/eks/kubeconfig_${TF_VAR_domain_name}" | sed -e "s/\./_/g")
if [[ "${ENABLE_K8_NOTIFICATION}" == "true" ]]; then
	kubectl get pods --all-namespaces | grep -E 'CrashLoopBackOff|Pending|Error'
fi
