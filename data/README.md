# Data

This directory contains the datasets used for training and evaluation.
Due to size constraints, most data must be downloaded externally before use.

## Directory Structure

```
data/
├── README.md
├── glucose/
│   └── y_glucose.csv            # small datasets included in repo
├── ...
├── reviews/
│   └── (see below)
├── gifteval/
│   └── (see below)
└── tsmixup/
    └── (see below)
```

## Setup

### Glucose, M5 (Shopping), Meditation, Patents, Police

Included in the repository. No action needed.

### Reviews (Amazon-Google)

This dataset is a preprocessed aggregation of [Google Local Reviews](https://mcauleylab.ucsd.edu/public_datasets/gdrive/googlelocal/) and [Amazon Reviews](https://amazon-reviews-2023.github.io/) which is too large to include in the repository. Download the preprocessed csv file from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/1276/amazon+product+and+google+locations+reviews)

### GiftEval Subsample

Download from HuggingFace:

```bash
huggingface-cli download Salesforce/GiftEval \
    --repo-type=dataset \
    --local-dir data/gifteval
```

Then run the preprocessing notebook:

```
data/gifteval/setup_gifteval.ipynb
```

### TSMixup (Training)

The training data used for training prediction heads uses the [Chronos TSMixup 10M](https://huggingface.co/datasets/autogluon/chronos_datasets)
corpus hosted on HuggingFace. It is downloaded, processed, and cached
automatically by `src/utils/data_loader.py`.

To trigger the download and processing manually:

```python
from src.utils.data_loader import create_cached_tsmixup_datasets

train_dataset, val_dataset = create_cached_tsmixup_datasets(
    max_samples=100000,        # adjust as needed
    context_length=512,
    prediction_length=128,
    cache_dir="data/tsmixup",  # raw HF cache location
    processed_cache_path="data/tsmixup/tsmixup_processed.pkl",
)
```

This will:

1. Download the raw dataset from HuggingFace (`autogluon/chronos_datasets`,
   config `training_corpus_tsmixup_10m`) into `cache_dir`.
2. Filter, validate, and preprocess each time series (length/quality checks,
   NaN/Inf removal, etc.).
3. Save the processed result as a pickle file at `processed_cache_path`.

Subsequent runs will load directly from the pickle cache unless
`force_reprocess=True` is passed.
