#!/bin/bash

CURRENT_DIR=$(pwd)

# Affichage d'un message d'aide si les paramètres ne sont pas fournis
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <carmentis_node_folder>"
  exit 1
fi


# Check if lz4 is installed
if ! command -v lz4 &> /dev/null
then
    echo "lz4 is not installed on the system."
    echo "You can install it using: sudo apt-get install lz4 (for Debian/Ubuntu) or sudo yum install lz4 (for CentOS/RHEL) or brew install lz4 (for MacOS)"
    exit 1
fi

# Variables pour le dossier et la commande
CARMENTIS_NODE_FOLDER=$1

# Vérification que le dossier existe
if [ ! -d "$CARMENTIS_NODE_FOLDER" ]; then
  echo "The directory doesn't exist : $CARMENTIS_NODE_FOLDER"
  exit 1
fi

# Exécution de la commande dans le dossier spécifié
cd "$CARMENTIS_NODE_FOLDER" || exit

timestamp=$(date +"%Y%m%d_%H%M%S")
./scripts/carmentis.sh stop && \
  tar -C "$CARMENTIS_NODE_FOLDER" -cf - .carmentis/data | lz4 > "$CURRENT_DIR/output/carmentis_$timestamp.tar.lz4" && \
  ./scripts/carmentis.sh start:themis


if [ $? -eq 0 ]; then
  exit 0
else
  echo "Failed to execute"
  exit 1
fi
