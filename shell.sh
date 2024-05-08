#!/bin/bash

# Define Kubernetes namespace and deployments
NAMESPACE="your-namespace"
DEPLOYMENTS=("deployment1" "deployment2" "deployment3")

# Retrieve and print original replica counts
for deployment in "${DEPLOYMENTS[@]}"; do
    original_replicas=$(kubectl get deployment "${deployment}" -n "${NAMESPACE}" -o jsonpath='{.spec.replicas}')
    echo "${deployment}:${original_replicas}"
done
