#!/bin/bash

# Script para atualizar o ficheiro /etc/hosts com os domínios e IPs do Minikube
CLUSTER_NAME="cluster-$(terraform workspace show)"
IP=$(minikube ip -p "$CLUSTER_NAME")

if [ -z "$IP" ]; then
    echo "❌ Erro: Não foi possível obter o IP do Minikube para o cluster $CLUSTER_NAME"
    exit 1
fi

echo "🌐 IP detetado para o cluster $CLUSTER_NAME: $IP"

# Busca todos os domínios definidos no Terraform para o cliente atual
DOMAINS=$(terraform output ../terraform/outputs.tf | jq -r '.[]' | sed 's/https:\/\///g')

for DOMAIN in $DOMAINS; do
    echo "🔗 A mapear $DOMAIN para $IP..."
    
    # Remove a entrada antiga se existir e adiciona a nova no /etc/hosts
    sudo sed -i "/$DOMAIN/d" /etc/hosts
    echo "$IP $DOMAIN" | sudo tee -a /etc/hosts > /dev/null
done

echo "✅ Ficheiro /etc/hosts atualizado com sucesso!"