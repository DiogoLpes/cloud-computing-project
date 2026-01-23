#!/bin/bash

# Busca as URLs do output do Terraform
URLS=$(terraform output -json application_urls | jq -r '.[]')

echo "🔍 A iniciar validação dos ambientes para o cliente: $(terraform workspace show)"
echo "------------------------------------------------------------"

for URL in $URLS; do
    echo -n "🌍 A testar $URL... "
    
    # -k ignora erro de certificado auto-assinado (Self-signed)
    # -s silent, -o dump output
    # -w código de resposta HTTP
    STATUS=$(curl -k -s -o /dev/null -w "%{http_code}" "$URL")

    if [ "$STATUS" == "200" ]; then
        echo "✅ [SUCCESS] (HTTP $STATUS)"
    else
        echo "❌ [FAILED] (HTTP $STATUS)"
    fi
done

echo "------------------------------------------------------------"
echo "🏁 Validação concluída."