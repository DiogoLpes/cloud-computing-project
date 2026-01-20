cd "$(dirname "$0")/../terraform"



# Get the list of instances from terraform output (or hardcode for now)
# For simplicity, we define the loop here based on your requirements
CLIENTS=("airbnb" "nike" "mcdonalds")
ENV_AIRBNB=("dev" "prod")
ENV_NIKE=("dev" "qa" "prod")
ENV_MCDONALDS=("dev" "qa" "beta" "prod")

provision() {
    local client=$1
    local env=$2
    local id="${client}-${env}"
    
    echo "----------------------------------------------------------"
    echo "🚀 Provisioning Cluster: $id"
    echo "----------------------------------------------------------"
    
    # We apply specifically the resources for this instance
    # The -target flag ensures we don't try to boot everything at once
    terraform apply -var-file=env.tfvars \
      -target="minikube_cluster.cluster[\"$id\"]" \
      -target="kubernetes_namespace.ns[\"$id\"]" \
      -target="kubernetes_stateful_set.postgres[\"$id\"]" \
      -target="kubernetes_deployment.odoo[\"$id\"]" \
      -target="kubernetes_ingress_v1.odoo_ingress[\"$id\"]" \
      -target="kubernetes_secret.odoo_tls[\"$id\"]" \
      -auto-approve

    echo "✅ Finished $id"
}

# Run the loop
for c in "${CLIENTS[@]}"; do
    case $c in
        airbnb) envs=("${ENV_AIRBNB[@]}") ;;
        nike) envs=("${ENV_NIKE[@]}") ;;
        mcdonalds) envs=("${ENV_MCDONALDS[@]}") ;;
    esac
    
    for e in "${envs[@]}"; do
        provision $c $e
    done
done