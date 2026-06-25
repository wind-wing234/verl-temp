# TextWorld Linux wheel cache

This repository caches the TextWorld Python package wheel for offline Linux
installation.

## Files

```text
vendor/textworld/textworld-1.7.0-py3-none-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl
```

SHA256:

```text
ca7486cff540c4d90865c54a3465e948c2790357aa78ad64de4406387854cbc8
```

The wheel is the TextWorld 1.7.0 Linux x86_64 prebuilt package from PyPI. It
requires Python 3.9 or newer.

## Offline install

On the target Linux machine:

```bash
git clone https://github.com/wind-wing234/verl-temp.git
cd verl-temp

python -m venv .venv
source .venv/bin/activate
python -m pip install -U pip

sha256sum -c vendor/textworld/textworld-1.7.0-py3-none-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl.sha256
python -m pip install --no-index --no-deps vendor/textworld/textworld-1.7.0-py3-none-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl
```

Use `--no-deps` when TextWorld's Python dependencies are already installed on
the target environment.

For a fully offline install including dependencies, put all dependency wheels in
`vendor/textworld/` as well, then install with:

```bash
python -m pip install --no-index --find-links vendor/textworld textworld==1.7.0
```
