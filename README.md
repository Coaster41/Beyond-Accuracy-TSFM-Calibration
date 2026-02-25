# Beyond Accuracy: Are Time Series Foundation Models Well-Calibrated?

Official Repository for the paper "Beyond Accuracy: Are Time Series Foundation Models Well-Calibrated" **Accepted at ICLR 2026**

[Paper](https://arxiv.org/abs/2510.16060) | [OpenReview](https://openreview.net/forum?id=nGBN7UjHcy)

## Authors

- Coen Adler - UC Irvine
- Yuxin Chang - UC Irvine
- Felix Draxler - UC Irvine
- Samar Abdi - Google
- Padhraic Smyth - UC Irvine

## Abstract

> The recent development of foundation models for time series data has generated considerable interest in using such models across a variety of applications.
Although foundation  models achieve state-of-the-art predictive performance, their calibration properties remain relatively underexplored, despite the fact that calibration can be critical for many practical applications. 
In this paper, we investigate the calibration-related properties of five recent time series foundation models and two competitive baselines. 
We perform a series of systematic evaluations assessing model calibration (i.e., over- or under-confidence), effects of varying prediction heads, and calibration under long-term autoregressive forecasting.
We find that time series foundation models are consistently better calibrated than baseline models and tend not to be either systematically over- or under-confident, in contrast to the overconfidence often seen in other deep learning models. 

## Repository Structure

```
├── environments/          # Environment setup scripts and requirements
├── src/                   # Source code (training, forecasting, evaluation)
└── data/                  # Datasets (see data/README.md for setup)
```

## Setup

### 1. Environments

Three separate venv/conda environments are required due to incompatible dependencies between models:

| Environment | Models / Purpose |
|---|---|
| `main` | TimesFM, Moirai2, Chronos-Bolt, evaluation & metrics |
| `yinglong` | Yinglong |
| `tirex` | TiRex |

To create all three environments:

```bash
cd environments
bash setup_all_envs.sh
```

### 2. Data

See [`data/README.md`](data/README.md) for instructions on obtaining all datasets.

## Usage

See [`src/README.md`](src/README.md) for instructions on training heads, running forecasts, and computing metrics.

## Citation

```bibtex
@inproceedings{
    CITATION_KEY,
    title={Beyond Accuracy: Are Time Series Foundation Models Well-Calibrated?},
    author={AUTHOR_NAMES},
    booktitle={The Fourteenth International Conference on Learning Representations},
    year={2026},
    url={https://openreview.net/forum?id=nGBN7UjHcy}
}
```

## License

[MIT License](LICENSE)
```