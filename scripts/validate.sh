#!/bin/bash

# 1. Garante que estamos na pasta onde o Terraform tem o estado
cd "$(dirname "$0")/../terraform" || exit

# 2. Busca as URLs (Garante que o output existe)
URLS=$(terraform output -json application_urls | jq -r '.[]' 2>/dev/null)

if [ -z "$URLS" ]; then
    echo "❌ Erro: Não foram encontradas URLs. O 'terraform apply' correu bem?"
    exit 1
fi

echo "🔍 A iniciar validação para o cliente: $(terraform workspace show)"
echo "------------------------------------------------------------"

for URL in $URLS; do
    # Adiciona https:// se não existir no output
    [[ "$URL" != http* ]] && TARGET="https://$URL" || TARGET="$URL"

    echo -n "🌍 A testar $TARGET... "
    
    # O Odoo responde 303 (Redirect) quando está saudável mas sem DB criada
    STATUS=$(curl -k -s -o /dev/null -w "%{http_code}" "$TARGET")

    if [ "$STATUS" == "200" ] || [ "$STATUS" == "303" ]; then
        echo "✅ [SUCCESS] (HTTP $STATUS)"
    else
        echo "❌ [FAILED] (HTTP $STATUS) - Verifica os pods ou o Ingress"
    fi
done

echo "------------------------------------------------------------"
echo "🏁 Validação concluída."