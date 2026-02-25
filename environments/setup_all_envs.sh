#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="$SCRIPT_DIR/environments"

# ---- Main environment (TimesFM, Moirai, Chronos-Bolt, evaluation) ----
echo "=== Creating main venv ==="
python3.10 -m venv envs/main
source envs/main/bin/activate
pip install --upgrade pip
pip install -r "$ENV_DIR/main.requirements.txt"
deactivate

# ---- Yinglong environment ----
echo "=== Creating yinglong venv ==="
python3.11 -m venv envs/yinglong
source envs/yinglong/bin/activate
pip install --upgrade pip
pip install -r "$ENV_DIR/yinglong.requirements.txt"
deactivate

# ---- TiRex environment (conda) ----
echo "=== Creating tirex conda env ==="
conda env create -f "$ENV_DIR/tirex.environment.yml"

echo "=== All environments created ==="