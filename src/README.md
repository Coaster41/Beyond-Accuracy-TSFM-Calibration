# Simple Usage Overview

## 1. Train Prediction Heads

Train prediction heads on cached latent representations from a backbone model.

```bash
python src/train_heads.py \
    --model-name <MODEL> \
    --heads <HEAD_TYPE> \
    --batch-size 512 \
    --tot-iters 2097152 \
    --epochs 3 \
    --lr 3e-4 \
    --weight-decay 1e-2 \
    --grad-clip 1.0 \
    --use-amp \
    --save-dir models \
    --save-prefix <PREFIX> \
    --context-len 512 \
    --device cuda \
    --max-label 1000 \
    --min-label-default -1000
```

| Argument | Description |
|---|---|
| `--model-name` | Backbone model: `timesfm`, `chronos_bolt`, `moirai2`, `tirex`, `yinglong` |
| `--heads` | One or more head types: `mse`, `gaussian`, `poisson`, `neg_binom`, `studentst`, `quantiles`, `mixture` |
| `--mixture_components` | Component distributions for mixture heads (one per head): `moirai`, `gaussian`, `studentst` |
| `--mixture_K` | Number of mixture components (one per head, integers) |
| `--save-dir` | Output directory for trained head checkpoints |

---

## 2. Run Forecaster

Generate forecasts using a backbone model with trained heads.

**Standard (non-AR) forecasting:**

```bash
python src/run_forecaster.py \
    --dataset data/<DATASET>/y_<DATASET>.csv \
    --model-name <MODEL> \
    --save-dir results \
    --ckpt-dir models \
    --pred-length 64 \
    --context-len 512 \
    --forecast-date "2021-01-31 23:00:00" \
    --stride 1 \
    --batch-size 512 \
    --device cuda \
    --heads quantiles studentst \
    --mixture_K 3 3 \
    --mixture_components gaussian gaussian
```

**Autoregressive forecasting:**

```bash
python src/run_forecaster.py \
    --dataset data/<DATASET>/y_<DATASET>.csv \
    --model-name <MODEL> \
    --save-dir results \
    --ckpt-dir models \
    --pred-length 64 \
    --context-len 512 \
    --forecast-date "2021-01-31 23:00:00" \
    --stride 1 \
    --batch-size 512 \
    --device cuda \
    --heads \
    --ar \
    --ar-step-len 16 \
    --ar-samples 100
```

| Argument | Description |
|---|---|
| `--dataset` | Path to CSV with columns `[unique_id, ds, y]` |
| `--heads` | Trained head names to evaluate; `backbone` is added automatically |
| `--ar` | Enable autoregressive forecasting |
| `--ar-step-len` | Tokens generated per AR iteration (≤ model horizon) |
| `--ar-samples` | Number of sampled trajectories for AR (omit for quantile-based AR) |
| `--save-dir` | Output directory for forecast CSVs |
| `--ckpt-dir` | Directory containing head checkpoints from step 1 |

---

## 3. Compute Metrics

Evaluate forecasts against ground-truth observations.

```bash
python src/metrics.py \
    --obs data/<DATASET>/y_<DATASET>.csv \
    --results_root results \
    --model_name <MODEL> \
    --head_name <HEAD> \
    --freq "H" \
    --q_low 0.1 \
    --q_high 0.9 \
    --confidence 0.8 \
    --wql_reduce mean \
    --wql_scale_mode sum_y \
    --out_per_h results/overall_per_h.csv \
    --out_per_h_by_series results/per_series_per_h.csv \
    --out_series_summary results/per_series_summary.csv \
    --out_summary results/overall_summary.json
```

| Argument | Description |
|---|---|
| `--obs` | Path to observations CSV with columns `[unique_id, ds, y]` |
| `--results_root` | Root directory containing forecast outputs from step 2 |
| `--model_name` | Model subdirectory under `results_root` |
| `--head_name` | Head subdirectory under `model_name` |
| `--freq` | Pandas frequency alias (`D`, `H`, `15min`, `W`, etc.) |
| `--out_per_h` | Output path for per-horizon metrics CSV |
| `--out_summary` | Output path for overall summary JSON |
| `--out_per_h_by_series` | Output path for per-series per-horizon metrics CSV |
| `--out_series_summary` | Output path for per-series summary CSV |

**Metrics computed:** MASE, SIW, PCE, TPCE, CCE, TCCE, WQL, MSIS — reported overall, per-horizon, and per-series.