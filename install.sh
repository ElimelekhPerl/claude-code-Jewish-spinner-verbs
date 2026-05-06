#!/usr/bin/env bash
#
# install.sh — Install Jewish spinner verbs into Claude Code.
# macOS / Linux. Requires: bash, curl, jq.
#
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/ElimelekhPerl/claude-code-Jewish-spinner-verbs/refs/heads/main/packages"
SETTINGS_DIR="${HOME}/.claude"
SETTINGS_FILE="${SETTINGS_DIR}/settings.json"

say()  { printf "\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m==>\033[0m %s\n" "$*" >&2; }
lc()   { echo "$1" | tr '[:upper:]' '[:lower:]'; }

# --- prerequisites ---
for cmd in curl jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    err "'$cmd' is required but not installed."
    [ "$cmd" = "jq" ] && err "  macOS: brew install jq   |   Debian: sudo apt-get install jq"
    exit 1
  fi
done

# --- choose package ---
echo
echo "Which verbs do you want to install?"
echo "  [y] Yeshivish  — beis medrash slang (Davening, Twirling tzitzis...)"
echo "  [i] Israeli    — Israeli slang in English (Yalla-ing, Eating shawarma...)"
echo "  [b] Both"
echo
read -rp "Package [y/i/b]: " PKG_CHOICE </dev/tty
case "$(lc "$PKG_CHOICE")" in
  y) PACKAGES="yeshivish" ;;
  i) PACKAGES="israeli" ;;
  b) PACKAGES="yeshivish israeli" ;;
  *) err "Invalid choice. Run the script again."; exit 1 ;;
esac

# --- choose mode ---
echo
echo "How should these verbs interact with the built-in Claude Code spinner?"
echo "  [a] Append   — add your verbs alongside the existing built-in list"
echo "  [r] Replace  — use only your verbs, drop all defaults"
echo
read -rp "Mode [a/r]: " MODE_CHOICE </dev/tty
case "$(lc "$MODE_CHOICE")" in
  a) MODE="append" ;;
  r) MODE="replace" ;;
  *) err "Invalid choice. Run the script again."; exit 1 ;;
esac

# --- fetch and combine selected packages ---
say "Fetching verb package(s): $PACKAGES..."
COMBINED_VERBS="[]"
for PKG in $PACKAGES; do
  TMP="$(mktemp)"
  trap 'rm -f "$TMP"' EXIT
  if ! curl -fsSL "${REPO_RAW}/${PKG}.json" -o "$TMP"; then
    err "Couldn't fetch ${PKG}.json. Check your internet connection."
    exit 1
  fi
  if ! jq empty "$TMP" 2>/dev/null; then
    err "Downloaded ${PKG}.json isn't valid JSON. Aborting."
    exit 1
  fi
  COMBINED_VERBS="$(jq -s '.[0] + .[1]' - "$TMP" <<< "$COMBINED_VERBS")"
done

# --- build spinnerVerbs config ---
TMP_CONFIG="$(mktemp)"
jq -n --argjson verbs "$COMBINED_VERBS" --arg mode "$MODE" \
  '{"spinnerVerbs": {"mode": $mode, "verbs": $verbs}}' > "$TMP_CONFIG"

# --- ensure settings dir exists ---
mkdir -p "$SETTINGS_DIR"

# --- decide what to do with existing settings ---
ACTION="install"
if [ -f "$SETTINGS_FILE" ]; then
  warn "Found existing settings at: $SETTINGS_FILE"
  echo
  echo "  [m] Merge     — keep your other settings, replace only spinnerVerbs"
  echo "  [o] Overwrite — replace the whole file (loses other settings)"
  echo "  [c] Cancel"
  echo
  read -rp "Choose [m/o/c]: " EXISTING_CHOICE </dev/tty
  case "$(lc "$EXISTING_CHOICE")" in
    m) ACTION="merge" ;;
    o) ACTION="overwrite" ;;
    *) say "Nothing done. Tzu gezunt."; exit 0 ;;
  esac
fi

# --- backup ---
if [ -f "$SETTINGS_FILE" ]; then
  BACKUP="${SETTINGS_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$SETTINGS_FILE" "$BACKUP"
  say "Backed up existing settings to: $BACKUP"
fi

# --- write ---
case "$ACTION" in
  install|overwrite)
    cp "$TMP_CONFIG" "$SETTINGS_FILE"
    ;;
  merge)
    MERGED="$(mktemp)"
    jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TMP_CONFIG" > "$MERGED"
    if ! jq empty "$MERGED" 2>/dev/null; then
      err "Merge produced invalid JSON. Your original settings are untouched."
      rm -f "$MERGED"
      exit 1
    fi
    mv "$MERGED" "$SETTINGS_FILE"
    ;;
esac

VERB_COUNT="$(jq '.spinnerVerbs.verbs | length' "$SETTINGS_FILE")"
say "Done. Installed ${VERB_COUNT} verbs (mode: ${MODE})."
say "Restart Claude Code to see the new spinner."
say "If you change your mind, your old settings are in the .bak file."
