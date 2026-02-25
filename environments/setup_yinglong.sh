#!/bin/bash
# ==============================================================
# Yinglong environment setup
#
# Prerequisites:
#   - conda or python3.11 available
#
# Usage: bash setup_yinglong.sh
# ==============================================================

set -e  # exit on any error

FLASH_ATTN_COMMIT="c4be578"

ENV_DIR="envs/yinglong"

echo "=== Creating virtual environment ==="
python3.11 -m venv "$ENV_DIR"
source "$ENV_DIR/bin/activate"

echo "=== Installing pip requirements ==="
pip install --upgrade pip
pip install -r environments/yinglong.requirements.txt

echo "=== Installing flash-attn (requires --no-build-isolation) ==="
pip install flash-attn==2.8.3 --no-build-isolation

echo "=== Cloning flash-attention for rotary & layer_norm ==="
if [ ! -d "flash-attention" ]; then
    git clone https://github.com/Dao-AILab/flash-attention.git
fi
cd flash-attention
git checkout "$FLASH_ATTN_COMMIT"

echo "=== Installing rotary-emb ==="
cd csrc/rotary && pip install . && cd ../..

echo "=== Installing dropout-layer-norm ==="
cd csrc/layer_norm && pip install . && cd ../..

cd ..

echo "=== Done ==="
echo "Activate with: source $ENV_DIR/bin/activate"