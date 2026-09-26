#!/bin/bash

setupExternalSecret()
{
    kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
    export EOS_ROLE_ARN=$(aws iam list-roles --query "Roles[?contains(RoleName, 'eso-role')].Arn" --output text)

    kubectl annotate serviceaccount external-secrets --namespace external-secrets eks.amazonaws.com/role-arn=$EOS_ROLE_ARN --overwrite

    kubectl rollout restart deployment/external-secrets -n external-secrets
    kubectl rollout status deployment/external-secrets -n external-secrets --timeout=120s

    kubectl apply -f ./ClusterSecretStore.yaml
    kubectl apply -f ./ExternalSecrets.yaml
}

verifyExternalSecret()
{
    kubectl get clustersecretstore
    kubectl get externalsecret -n dev
    kubectl get secrets -n dev
}

setupExternalSecret
verifyExternalSecret