from pathlib import Path

for pattern in ("data/raw/*.csv", "data/processed/*.parquet", "data/exports/*.csv", "artifacts/*"):
    for path in Path(".").glob(pattern):
        if path.is_file():
            path.unlink()
