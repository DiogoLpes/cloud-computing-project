.PHONY: help init validate fmt plan deploy-sequencial destroy-sequencial clean output

help:
	@echo "🌟 Odoo Multi-Client Provisioning"
	@echo "==============================="
	@echo "Comandos Sequenciais (Recomendado):"
	@echo "  make deploy-all      - Cria clusters e apps para TODOS os clientes"
	@echo "  make destroy-all     - Remove TUDO de todos os clientes"
	@echo ""
	@echo "Comandos Individuais (Requer workspace selecionado):"
	@echo "  make init            - Inicializa Terraform"
	@echo "  make apply           - Apply no workspace atual"
	@echo "  make output          - Mostra URLs do workspace atual"

# Variáveis
TF_DIR = .
CLIENTS = airbnb nike mcdonalds

.PHONY: all init apply-all clean

# Comando padrão
all: init apply-all

init:
	terraform init -upgrade
	-terraform workspace new airbnb
	-terraform workspace new nike
	-terraform workspace new mcdonalds


apply:
	@if [ -z "$(client)" ]; then echo "Error: Please specify client (e.g., make apply client=airbnb)"; exit 1; fi
	terraform workspace select $(client)
	terraform apply -auto-approve -parallelism=1


apply-all: 
	$(MAKE) apply client=airbnb
	$(MAKE) apply client=nike
	$(MAKE) apply client=mcdonalds

# Limpeza total (Cuidado: apaga tudo no Docker/Minikube)
clean:
	@echo "⚠️ A limpar todos os recursos..."
	-minikube delete --all
	-docker system prune -f
	-rm -rf terraform.tfstate* .terraform/ certs/ .terraform.lock.hcl


destroy-all:
	@for client in $(CLIENTS); do \
		echo "💥 >>> DESTRUINDO CLIENTE: $$client <<<"; \
		terraform workspace select $$client && terraform destroy -var-file=$(VAR_FILE) -auto-approve; \
	done



# Atualiza o arquivo hosts 
hosts: 
	./scripts/update_hosts.sh

# Valida os ambientes com curl
validate: 
	./scripts/validate.sh
	

# Atalho completo para um cliente
deploy: 
	apply-all hosts validate

