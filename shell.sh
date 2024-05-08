#!/bin/bash

# Define Kubernetes namespace and deployments
NAMESPACE="default"
DEPLOYMENTS=("deployment-1" "deployment-2" "deployment-3")

# Retrieve and print original replica counts
for deployment in "${DEPLOYMENTS[@]}"; do
    original_replicas=$(kubectl get deployment "${deployment}" -n "${NAMESPACE}" -o jsonpath='{.spec.replicas}')
    echo "${deployment}:${original_replicas}"
done
