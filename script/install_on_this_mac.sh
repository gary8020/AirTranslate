#!/usr/bin/env bash
set -euo pipefail

# Build Gary's privacy-fixed AirTranslate branch locally and install it for the
# current macOS user. No API keys or saved application data are copied.

REPOSITORY_URL="${AIRTRANSLATE_REPOSITORY_URL:-https://github.com/gary8020/AirTranslate.git}"
SOURCE_BRANCH="${AIRTRANSLATE_SOURCE_BRANCH:-distribution/cross-mac-installer}"
SOURCE_DIR="${AIRTRANSLATE_SOURCE_DIR:-${HOME}/Library/Application Support/AirTranslate Custom Build/source}"
INSTALL_DIR="${AIRTRANSLATE_INSTALL_DIR:-${HOME}/Applications}"
APP_NAME="AirTranslate"
APP_SOURCE="$SOURCE_DIR/dist/$APP_NAME.app"
APP_TARGET="$INSTALL_DIR/$APP_NAME.app"
MODE="${1:-install}"
STAGING_DIR=""

fail() {
  echo "AirTranslate installer: $*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

cleanup() {
  if [[ -n "$STAGING_DIR" && -d "$STAGING_DIR" ]]; then
    rm -rf -- "$STAGING_DIR"
  fi
}

trap cleanup EXIT

check_mac() {
  [[ "$(uname -s)" == "Darwin" ]] || fail "this installer runs only on macOS"
  [[ "$(uname -m)" == "arm64" ]] || fail "this build currently supports Apple Silicon Macs only"

  local major_version
  major_version="$(sw_vers -productVersion | cut -d. -f1)"
  [[ "$major_version" =~ ^[0-9]+$ ]] || fail "could not determine the macOS version"
  (( major_version >= 26 )) || fail "macOS 26 or later is required"

  require_command git
  require_command swift
  require_command xcode-select
  require_command codesign
  require_command ditto
  xcode-select -p >/dev/null 2>&1 || fail "install Xcode Command Line Tools first: xcode-select --install"
}

prepare_source() {
  if [[ -e "$SOURCE_DIR" && ! -d "$SOURCE_DIR/.git" ]]; then
    fail "$SOURCE_DIR exists but is not an AirTranslate Git checkout"
  fi

  if [[ -d "$SOURCE_DIR/.git" ]]; then
    local current_repository_url
    current_repository_url="$(git -C "$SOURCE_DIR" remote get-url origin)"
    [[ "$current_repository_url" == "$REPOSITORY_URL" ]] ||
      fail "$SOURCE_DIR points to $current_repository_url instead of $REPOSITORY_URL"
    [[ -z "$(git -C "$SOURCE_DIR" status --short)" ]] ||
      fail "$SOURCE_DIR has local changes; move or commit them before updating"
    git -C "$SOURCE_DIR" fetch --prune origin "$SOURCE_BRANCH"
    git -C "$SOURCE_DIR" switch --detach "origin/$SOURCE_BRANCH"
  else
    mkdir -p "$(dirname "$SOURCE_DIR")"
    git clone --branch "$SOURCE_BRANCH" --single-branch "$REPOSITORY_URL" "$SOURCE_DIR"
  fi
}

install_app() {
  mkdir -p "$INSTALL_DIR"

  STAGING_DIR="$(mktemp -d "$INSTALL_DIR/.airtranslate-install.XXXXXX")"

  (
    cd "$SOURCE_DIR"
    ./script/build_and_run.sh --build-only
  )

  [[ -d "$APP_SOURCE" ]] || fail "build completed without producing $APP_SOURCE"
  ditto "$APP_SOURCE" "$STAGING_DIR/$APP_NAME.app"
  codesign --verify --deep --strict "$STAGING_DIR/$APP_NAME.app"

  if [[ -e "$APP_TARGET" ]]; then
    local backup_path
    backup_path="$INSTALL_DIR/$APP_NAME-backup-$(date +%Y%m%d-%H%M%S).app"
    mv "$APP_TARGET" "$backup_path"
    echo "Previous app preserved at $backup_path"
  fi

  mv "$STAGING_DIR/$APP_NAME.app" "$APP_TARGET"
  rmdir "$STAGING_DIR"
  STAGING_DIR=""
}

check_mac

if [[ "$MODE" == "--check" || "$MODE" == "check" ]]; then
  echo "Compatible Mac detected. AirTranslate can be installed for this user."
  exit 0
fi

if [[ "$MODE" != "install" && "$MODE" != "--no-launch" && "$MODE" != "no-launch" ]]; then
  fail "usage: $0 [install|--check|--no-launch]"
fi

prepare_source
install_app

echo "Installed $APP_TARGET"
echo "Source commit: $(git -C "$SOURCE_DIR" rev-parse HEAD)"

if [[ "$MODE" == "install" ]]; then
  pkill -x "$APP_NAME" >/dev/null 2>&1 || true
  open "$APP_TARGET"
  echo "AirTranslate opened. Approve Microphone and Speech Recognition if macOS asks."
fi
