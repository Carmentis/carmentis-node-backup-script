#!/bin/bash

#
# Copyright (c) Carmentis. All rights reserved.
# Licensed under the Apache 2.0 licence.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

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
  ./scripts/carmentis.sh start:themis && \
  echo "Backup created successfully in $CURRENT_DIR/output/carmentis_$timestamp.tar.lz4"


if [ $? -eq 0 ]; then
  exit 0
else
  echo "Failed to execute"
  exit 1
fi
