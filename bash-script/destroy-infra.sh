#!/bin/bash
kubectl delete externalsecret --all -n dev
kubectl delete clustersecretstore aws-secrets-manager
kubectl delete ingress $(kubectl get  ingress -n dev -o json | jq -r '.items.[0].metadata.name') -n dev
kubectl delete ingress $(kubectl get  ingress -n argocd -o json | jq -r '.items.[0].metadata.name') -n argocd

helm uninstall external-secrets -n external-secrets
helm uninstall argocd -n argocd
helm uninstall aws-load-balancer-controller -n kube-system

kubectl delete namespace argocd external-secrets dev --ignore-not-found