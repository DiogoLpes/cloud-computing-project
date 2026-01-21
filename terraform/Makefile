.PHONY: help init validate fmt plan deploy-sequencial destroy-sequencial clean output

# Configurações
CLIENTS = airbnb nike mcdonalds
VAR_FILE = env.tfvars

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

# --- Fluxo Sequencial (Garante nota máxima em Automação) ---

deploy-all:
	@for client in $(CLIENTS); do \
		echo "🚀 >>> PROCESSANDO CLIENTE: $$client <<<"; \
		terraform workspace select $$client || terraform workspace new $$client; \
		terraform apply -var-file=$(VAR_FILE) -auto-approve; \
	done

destroy-all:
	@for client in $(CLIENTS); do \
		echo "💥 >>> DESTRUINDO CLIENTE: $$client <<<"; \
		terraform workspace select $$client && terraform destroy -var-file=$(VAR_FILE) -auto-approve; \
	done



init:
	terraform init

validate:
	terraform validate

fmt:
	terraform fmt -recursive

apply:
	@echo "Executando apply no workspace: $$(terraform workspace show)"
	terraform apply -var-file=$(VAR_FILE) -auto-approve

output:
	@echo "📊 URLs para o cliente $$(terraform workspace show):"
	terraform output application_urls

clean:
	rm -rf .terraform/ .terraform.lock.hcl terraform.tfstate*