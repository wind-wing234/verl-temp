#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wheelhouse="$repo_root/vendor/textworld/wheelhouse"

arch="$(uname -m)"
case "$arch" in
  aarch64|arm64) ;;
  *)
    echo "Unsupported architecture: $arch. This offline bundle is for Linux aarch64." >&2
    exit 1
    ;;
esac

python - <<'PY'
import sys
if sys.version_info[:2] != (3, 11):
    raise SystemExit(
        "This wheelhouse was prepared for Python 3.11 on aarch64. "
        f"Current Python is {sys.version.split()[0]}."
    )
PY

for tool in make cc; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required build tool: $tool" >&2
    echo "Install system build tools first, e.g. build-essential and python3.11-dev on Debian/Ubuntu." >&2
    exit 1
  fi
done

if [[ ! -d "$wheelhouse" ]]; then
  echo "Missing wheelhouse: $wheelhouse" >&2
  exit 1
fi

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

python -m pip install --no-index --find-links "$wheelhouse" setuptools wheel
python -m pip install --no-index --find-links "$wheelhouse" "$wheelhouse/jericho-3.3.1.tar.gz"

tar -xzf "$wheelhouse/textworld-1.7.0.tar.gz" -C "$tmpdir"
textworld_src="$tmpdir/textworld-1.7.0"

python - "$textworld_src/setup.py" <<'PY'
from pathlib import Path
import sys

setup_py = Path(sys.argv[1])
text = setup_py.read_text(encoding="utf-8")
old = """def _pre_install(dir):
    from subprocess import check_call
    check_call(['./setup.sh'], shell=True, cwd=os.getcwd())
"""
new = """def _pre_install(dir):
    if os.environ.get("TEXTWORLD_SKIP_INFORM7") == "1":
        print("Skipping Inform7 setup on unsupported aarch64 platform.")
        return
    from subprocess import check_call
    check_call(['./setup.sh'], shell=True, cwd=os.getcwd())
"""
if old not in text:
    raise SystemExit("Could not patch TextWorld setup.py; upstream layout changed.")
setup_py.write_text(text.replace(old, new), encoding="utf-8")
PY

TEXTWORLD_SKIP_INFORM7=1 python -m pip install --no-index --find-links "$wheelhouse" --no-build-isolation "$textworld_src"

python - <<'PY'
import jericho
import textworld
print("Installed jericho", getattr(jericho, "__version__", "unknown"))
print("Installed textworld", getattr(textworld, "__version__", "unknown"))
PY
