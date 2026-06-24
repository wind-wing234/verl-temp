#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
archive="$repo_root/vendor/textworld/I7_6M62_Linux_all.tar.gz"
expected_sha256="684e33d37e6fd21a1822233ddf35937f3a365c4a366486a113c5f32015d93cbd"

if [[ ! -f "$archive" ]]; then
  echo "Missing Inform7 archive: $archive" >&2
  exit 1
fi

actual_sha256="$(sha256sum "$archive" | awk '{print $1}')"
if [[ "$actual_sha256" != "$expected_sha256" ]]; then
  echo "Inform7 archive checksum mismatch." >&2
  echo "Expected: $expected_sha256" >&2
  echo "Actual:   $actual_sha256" >&2
  exit 1
fi

textworld_dir="${TEXTWORLD_DIR:-$repo_root/TextWorld}"

if [[ ! -d "$textworld_dir/.git" ]]; then
  git clone https://github.com/microsoft/TextWorld.git "$textworld_dir"
fi

thirdparty_dir="$textworld_dir/textworld/thirdparty"
if [[ ! -d "$thirdparty_dir" ]]; then
  echo "Invalid TextWorld checkout, missing: $thirdparty_dir" >&2
  exit 1
fi

cp "$archive" "$thirdparty_dir/I7_6M62_Linux_all.tar.gz"
python -m pip install "$textworld_dir[pddl]"
