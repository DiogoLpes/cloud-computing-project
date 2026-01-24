#!/bin/bash

# 1. Entrar na pasta onde está o Terraform para saber o workspace e o estado
cd "$(dirname "$0")/../terraform" || exit

# 2. Obter o nome do cliente/workspace
CLIENT=$(terraform workspace show)
CLUSTER_NAME="cluster-$CLIENT"

# 3. Obter o IP do Minikube
IP=$(minikube ip -p "$CLUSTER_NAME")

if [ -z "$IP" ]; then
    echo "❌ Erro: Não foi possível obter o IP para o cluster $CLUSTER_NAME"
    exit 1
fi

echo "🌐 IP detetado para o cluster $CLUSTER_NAME: $IP"

# 4. Extrair domínios do output do Terraform (forma segura via JSON)
# Nota: o output 'application_urls' deve estar definido nos teos ficheiros .tf
DOMAINS=$(terraform output -json application_urls | jq -r '.[]' | sed 's/https:\/\///g')

if [ -z "$DOMAINS" ] || [ "$DOMAINS" == "null" ]; then
    echo "⚠️ Aviso: Nenhum domínio encontrado no output do Terraform."
    exit 0
fi

TEMP_HOSTS=$(grep -v ".mcdonalds.local" /etc/hosts)

for DOMAIN in $DOMAINS; do
    echo "🔗 A mapear $DOMAIN para $IP..."
    TEMP_HOSTS+=$'\n'"$IP $DOMAIN"
done

# Escreve tudo de uma vez (precisa de sudo)
echo "$TEMP_HOSTS" | sudo tee /etc/hosts > /dev/null