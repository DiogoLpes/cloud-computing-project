#!/bin/bash

# This script needs sudo to edit /etc/hosts
echo "Updating /etc/hosts..."

# Get all cluster names
CLUSTERS=$(minikube profile list -o json | jq -r '.valid[].Name' 2>/dev/null)

for CLUSTER in $CLUSTERS; do
    IP=$(minikube ip -p $CLUSTER)
    # Extract client and env from name (format: client-env)
    CLIENT=$(echo $CLUSTER | cut -d'-' -f1)
    ENV=$(echo $CLUSTER | cut -d'-' -f2)
    DOMAIN="odoo.${ENV}.${CLIENT}.local"

    # Remove old entry if exists
    sudo sed -i "/$DOMAIN/d" /etc/hosts
    
    # Add new entry
    echo "$IP $DOMAIN" | sudo tee -a /etc/hosts
done

echo "Hosts updated successfully."