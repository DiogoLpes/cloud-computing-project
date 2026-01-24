# ☁️ Cloud Computing Project - Odoo Multi-Instance Cluster
Este projeto automatiza o deployment de instâncias multi-tenant do ERP **Odoo** num cluster **Kubernetes (Minikube)** utilizando **Terraform**.

## 🚀 Arquitetura
A infraestrutura é segmentada por namespaces para cada ambiente do cliente (Dev, QA, Beta, Prod), garantindo isolamento de recursos e base de dados.

- **Orquestração:** Kubernetes (Minikube)
- **IaC:** Terraform com suporte a Workspaces
- **Base de Dados:** PostgreSQL 15 (StatefulSet com persistência)
- **Aplicação:** Odoo 16.0
- **Ingress:** Nginx Ingress Controller com suporte a TLS



---

## 🛠️ Como Executar

### 1. Pré-requisitos
Certifique-se de ter instalado:
- Docker
- Minikube
- Terraform
- jq (para processamento de outputs)

### 2. Iniciar o Cluster
```bash
make init
```

### 3. Deploy da Infraestrutura um por um
# Inicializa o Terraform e aplica a configuração
```bash
make apply (e.g., client=airbnb)
```

### 3. Deploy da Infraestrutura completa
```bash
make apply-all
```

### 4. Configurar DNS Local
```bash
make hosts
```

### 5. Validação 
```bash
make validate
```

### 6. Limpeza
```bash
make clean
```