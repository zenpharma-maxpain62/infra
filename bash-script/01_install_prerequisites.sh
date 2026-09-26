#!/bin/bash
echo "------------------------------"
echo "Adding helm repositories"
echo "------------------------------"
helm repo add eks https://aws.github.io/eks-charts
helm repo add external-secrets https://charts.external-secrets.io
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
echo "------------------------------------------"
echo "helm repositories added successfully"
echo "------------------------------------------"


helm list -A | grep -i aws-load-balancer-controller > /dev/null 2>&1
export AWS_LB_CONTROLLER_STATUS=$(echo $?)
kubectl get pods -A | grep -i "aws-load-balancer-controller-" > /dev/null 2>&1 > /dev/null 2>&1
export AWS_LB_POD_STATUS=$(echo $?)

if [[ $AWS_LB_CONTROLLER_STATUS -eq 0 ]] && [[ $AWS_LB_POD_STATUS -eq 0 ]]; then
	echo "AWS Load Balancer Controller is installed"
else
	echo "------------------------------------------"
	echo "Installing AWS Load Balancer Controller"
	echo "------------------------------------------"
	VPCID=$(aws eks describe-cluster --name zenpharma-dev-cluster --region ap-south-1 --query "cluster.resourcesVpcConfig.vpcId" --output text)
	ALB_Controller_Role_ARN=$(aws iam list-roles --query "Roles[?contains(RoleName, 'alb-controller')].Arn" --output text)
	helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
	--namespace kube-system \
	--set clusterName=zenpharma-dev-cluster  \
	--set region=ap-south-1 \
	--set vpcId=$VPCID \
	--set serviceAccount.create=true \
  	--set serviceAccount.name=aws-load-balancer-controller \
  	--set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=$ALB_Controller_Role_ARN" \
  	--wait --timeout 5m 
	if [[ $? == 0 ]]; then
	echo "------------------------------------------"
	echo "AWS Load Balancer Controller installed successfully"
	echo "------------------------------------------"
	else 
        echo -e "\e[31m------------------------------------------------------\e[0m"
        echo -e "\e[31mPlease verify if AWS Load Balancer Controller Installed successfully or not\e[0m"
        echo -e "\e[31m------------------------------------------------------\e[0m"
	fi
fi
unset $AWS_LB_CONTROLLER_STATUS
unset $AWS_LB_POD_STATUS


helm list -A | grep -i argocd > /dev/null 2>&1
export ARGO_HELM_STATUS=$(echo $?)
kubectl get pods -A | grep -i "argocd-" > /dev/null 2>&1 > /dev/null 2>&1
export ARGO_POD_STATUS=$(echo $?)

if [[ $ARGO_HELM_STATUS -eq 0 ]] && [[ $ARGO_POD_STATUS -eq 0 ]]; then
	echo "argocd is installed"
else
	echo "------------------------------------------"
	echo "Installing argocd"
	echo "------------------------------------------"
	helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace --wait --timeout 10m
	if [[ $? == 0 ]]; then
	echo "------------------------------------------"
	echo "argocd installed successfully"
	echo "------------------------------------------"
	else 
        echo -e "\e[31m------------------------------------------------------\e[0m"
        echo -e "\e[31mPlease verify if AWS Load Balancer Controller Installed successfully or not\e[0m"
        echo -e "\e[31m------------------------------------------------------\e[0m"
	fi
fi
unset $ARGO_HELM_STATUS
unset $ARGO_POD_STATUS

helm list -A | grep -i external-secrets > /dev/null 2>&1
export EXTERNAL_SECRET_OPERATOR_STATUS=$(echo $?)
kubectl get pods -A | grep -i "external-secrets-" > /dev/null 2>&1 > /dev/null 2>&1
export EXTERNAL_SECRET_POD_STATUS=$(echo $?)

if [[ $EXTERNAL_SECRET_OPERATOR_STATUS -eq 0 ]] && [[ $EXTERNAL_SECRET_POD_STATUS -eq 0 ]]; then
	echo "External Secrets Operator is installed"
else
	echo "------------------------------------------"
	echo "Installing External Secrets Operator"
	echo "------------------------------------------"
	helm upgrade --install external-secrets external-secrets/external-secrets \
  	--namespace external-secrets \
  	--create-namespace \
  	--set installCRDs=true \
  	--wait --timeout 5m
	if [[ $? == 0 ]]; then
	echo "------------------------------------------"
	echo "External Secrets Operator installed successfully"
	echo "------------------------------------------"
	else 
        echo -e "\e[31m------------------------------------------------------\e[0m"
        echo -e "\e[31mPlease verify if External Secrets Operator Installed successfully or not\e[0m"
        echo -e "\e[31m------------------------------------------------------\e[0m"
	fi
fi
unset $EXTERNAL_SECRET_OPERATOR_STATUS
unset $EXTERNAL_SECRET_POD_STATUS


echo "------------------------------------------"
echo "Verification"
echo "------------------------------------------"
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
kubectl get pods -n argocd
kubectl get pods -n external-secrets