# TextWorld aarch64 offline bundle

This repository caches the packages needed to install TextWorld 1.7.0 on an
offline Linux aarch64 server with Python 3.11.

PyPI only publishes TextWorld's prebuilt Linux wheel for x86_64. For aarch64,
this bundle installs TextWorld from source and uses a local wheelhouse for its
Python dependencies.

## Important limitation

TextWorld's upstream source install runs `setup.sh`, which installs Inform7.
The Inform7 6M62 Linux archive does not contain `aarch64` compiler binaries, so
the upstream install cannot complete unchanged on aarch64.

The included installer patches TextWorld setup locally to skip Inform7 on
aarch64. This is enough for importing TextWorld and using Jericho-backed
existing games, but TextWorld game generation through Inform7 is not available
on this platform.

## Files

```text
vendor/textworld/wheelhouse/
scripts/install_textworld_aarch64_offline.sh
```

`vendor/textworld/wheelhouse/SHA256SUMS` contains checksums for the cached
source packages and wheels.

## Install on the offline aarch64 server

System prerequisites must already be installed on the server:

```bash
sudo apt install build-essential python3.11 python3.11-venv python3.11-dev
```

Then install from this repository without network access:

```bash
git clone https://github.com/wind-wing234/verl-temp.git
cd verl-temp

python3.11 -m venv .venv
source .venv/bin/activate

sha256sum -c vendor/textworld/wheelhouse/SHA256SUMS
bash scripts/install_textworld_aarch64_offline.sh
```

Verify:

```bash
python - <<'PY'
import textworld
import jericho
print(textworld.__version__)
print(jericho.__version__)
PY
```
