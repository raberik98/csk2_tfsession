#!/usr/bin/env bash
set -euo pipefail

WORKSPACE=$1
FUNCTION=$2

VAR_FILE="configs/$WORKSPACE/terraform.tfvars"
BACKEND_CONFIG="configs/$WORKSPACE/state.config"

case $FUNCTION in
    init) 
        terraform init -reconfigure -backend-config="$BACKEND_CONFIG" ;;
    validate) 
        terraform validate ;;
    plan|apply|destroy)
        # terraform init -reconfigure -backend-config="$BACKEND_CONFIG" >/dev/null

        if terraform workspace list | grep -qE "^\*? *${WORKSPACE}$"; then
            terraform workspace select "$WORKSPACE"
        else
            terraform workspace new "$WORKSPACE"
        fi

        terraform "$FUNCTION" -var-file="$VAR_FILE" 
        ;;
esac