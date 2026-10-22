#!/bin/bash
#
# Instalacion y enlace del agente Tenable (Nessus Agent) en Linux
# Ejecutar como root o con sudo.

# Clave de enlace (linking key) de Tenable Vulnerability Management.
# Mejor pasarla como variable de entorno: TENABLE_KEY=xxxx ./InstallNessusAgent.sh
TENABLE_KEY="${TENABLE_KEY:-PEGAR_AQUI_LA_LINKING_KEY}"

# Nombre del agente (por defecto, el hostname) y grupo de agentes en Tenable
AGENT_NAME="${AGENT_NAME:-$(hostname)}"
AGENT_GROUP="${AGENT_GROUP:-agent-group}"

set -o pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root (usa sudo)." >&2
    exit 1
fi

if [ "$TENABLE_KEY" = "PEGAR_AQUI_LA_LINKING_KEY" ]; then
    echo "Falta la clave de Tenable (TENABLE_KEY)." >&2
    exit 1
fi

echo "Instalando agente Tenable: nombre=${AGENT_NAME}, grupo=${AGENT_GROUP}"

curl -sSf -H "X-Key: ${TENABLE_KEY}" \
    "https://sensor.cloud.tenable.com/install/agent?name=${AGENT_NAME}&groups=${AGENT_GROUP}" | bash

if [ $? -eq 0 ]; then
    echo "Agente instalado y enlazado correctamente."
else
    echo "Error durante la instalacion del agente." >&2
    exit 1
fi
