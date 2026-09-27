#!/bin/bash
kubectl delete externalsecret --all -n dev
kubectl delete clustersecretstore aws-secrets-manager

helm uninstall external-secrets -n external-secrets
helm uninstall argocd -n argocd
helm uninstall aws-load-balancer-controller -n kube-system

kubectl delete namespace argocd external-secrets dev --ignore-not-found