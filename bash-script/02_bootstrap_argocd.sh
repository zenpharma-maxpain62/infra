#!/bin/bash

read "Enter github url: " GITHUB_URL
read "Enter github username: " GITHUB_USERNAME
read -rsp "Enter GitHub PAT: " GITHUB_PAT

registerGitopsRepository()
{
	kubectl get secret zen-gitops-repo -n argocd > /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
	echo "secret zen-gitops-repo is present"
	else
		echo "------------------------------------------"
		echo "Register the GitOps Repository in ArgoCD"
		echo "------------------------------------------"
		read -rsp "Enter GitHub PAT: " GITHUB_PAT
		# Create the secret with repo credentials
		kubectl create secret generic zen-gitops-repo \
		  --namespace argocd \
		  --from-literal=type=git \
		  --from-literal=url=$GITHUB_URL \
		  --from-literal=username=$GITHUB_USERNAME \
		  --from-literal=password=$GITHUB_PAT \
		  --dry-run=client -o yaml | kubectl apply -f -

		# Label it so ArgoCD recognizes it as a repository
		kubectl label secret zen-gitops-repo argocd.argoproj.io/secret-type=repository --namespace argocd --overwrite
        
		kubectl get secret zen-gitops-repo -n argocd > /dev/null 2>&1
		if [[ $? == 0 ]]; then
		echo "------------------------------------------"
		echo "GitOps Repository in ArgoCD register successfully"
		echo "------------------------------------------"
		else
		echo -e "\e[31m------------------------------------------------------\e[0m"
    	echo -e "\e[31mFailed to register GitOps repository in ArgoCD\e[0m"
    	echo -e "\e[31m------------------------------------------------------\e[0m"
		fi
	fi
unset $GITHUB_PAT
}

createPharmaProject()
{
    kubectl apply -f ./pharma-project.yaml
}

registerGitopsRepository
createPharmaProject