# TextWorld Inform7 cache

This repository caches the Inform7 CLI archive needed by TextWorld's
`setup.sh`.

TextWorld downloads this file during source installation:

```text
http://emshort.com/inform-app-archive/6M62/I7_6M62_Linux_all.tar.gz
```

If a machine cannot access `emshort.com`, install TextWorld from source after
pre-seeding the archive into `textworld/thirdparty/`.

## Files

```text
vendor/textworld/I7_6M62_Linux_all.tar.gz
```

SHA256:

```text
684e33d37e6fd21a1822233ddf35937f3a365c4a366486a113c5f32015d93cbd
```

## Install TextWorld for ALFWorld

On the target Linux machine:

```bash
git clone https://github.com/wind-wing234/verl-temp.git
cd verl-temp

python -m venv .venv
source .venv/bin/activate
python -m pip install -U pip setuptools wheel

./scripts/install_textworld_with_cached_inform7.sh
python -m pip install alfworld
```

The script clones `microsoft/TextWorld`, copies the cached Inform7 archive into
`TextWorld/textworld/thirdparty/`, then installs `TextWorld[pddl]` from the local
source checkout.

If you already have a TextWorld source checkout:

```bash
TEXTWORLD_DIR=/path/to/TextWorld ./scripts/install_textworld_with_cached_inform7.sh
```

## Manual Steps

```bash
git clone https://github.com/microsoft/TextWorld.git
cp vendor/textworld/I7_6M62_Linux_all.tar.gz TextWorld/textworld/thirdparty/
python -m pip install "./TextWorld[pddl]"
```
