#!/bin/bash
set -e

# Cores para o terminal
GREEN='\033[0;32m'
NC='\033[0m'

TERRAFORM_DIR="terraform"
# Lista baseada nos seus dados em locals.tf [cite: 5, 6]
ENVIRONMENTS=("airbnb-dev" "airbnb-prod" "nike-dev" "nike-qa" "nike-prod" "mcdonalds-dev" "mcdonalds-qa" "mcdonalds-beta" "mcdonalds-prod")

echo "🚀 Iniciando Implantação Sequencial..."

cd "$TERRAFORM_DIR"

for env in "${ENVIRONMENTS[@]}"; do
  echo -e "${GREEN}📦 Implantando Ambiente: $env${NC}"
  
  # 1. Provisiona apenas o cluster Minikube específico 
  terraform apply -target="minikube_cluster.cluster[\"$env\"]" -var-file="env.tfvars" -auto-approve

  # 2. Configura o contexto do kubectl para o novo cluster
  minikube update-context -p "$env"
  
  # 3. Provisiona os recursos K8s dentro desse cluster [cite: 7, 20]
  terraform apply \
    -target="kubernetes_namespace.ns[\"$env\"]" \
    -target="kubernetes_stateful_set.postgres[\"$env\"]" \
    -target="kubernetes_service.postgres_service[\"$env\"]" \
    -target="kubernetes_deployment.odoo[\"$env\"]" \
    -target="kubernetes_service.odoo_service[\"$env\"]" \
    -target="kubernetes_ingress_v1.odoo_ingress[\"$env\"]" \
    -var-file="env.tfvars" -auto-approve

  echo -e "✅ Ambiente $env concluído.\n"
done