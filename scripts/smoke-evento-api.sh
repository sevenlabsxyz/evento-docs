#!/usr/bin/env bash
set -euo pipefail
usage() {
  cat <<'EOF_USAGE'
Usage:
  ./scripts/smoke-evento-api.sh --api-key <API_KEY> [--base-url <URL>] [--event-id <EVENT_ID>] [--username <USERNAME>] [--auth-header <x-evento-api-key|authorization>]
Arguments:
  --api-key       API key for the public API (x-evento-api-key by default)
  --base-url      API base URL (default: http://localhost:3002)
  --event-id      Event id for event endpoints (default: evt_abc123)
  --username      Username for user feed endpoints (default: johndoe)
  --auth-header   auth mode: x-evento-api-key or authorization (default: x-evento-api-key)
Any value may also be provided via environment variables:
  EVENTO_API_KEY, BASE_URL, EVENT_ID, USERNAME, AUTH_HEADER
EOF_USAGE
}
BASE_URL="${BASE_URL:-http://localhost:3002}"
API_KEY="${EVENTO_API_KEY:-}"
EVENT_ID="${EVENT_ID:-evt_abc123}"
USERNAME="${USERNAME:-johndoe}"
AUTH_HEADER_MODE="${AUTH_HEADER:-x-evento-api-key}"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --api-key)
      API_KEY="$2"
      shift 2
      ;;
    --base-url)
      BASE_URL="$2"
      shift 2
      ;;
    --event-id)
      EVENT_ID="$2"
      shift 2
      ;;
    --username)
      USERNAME="$2"
      shift 2
      ;;
    --auth-header)
      AUTH_HEADER_MODE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done
if [[ "$AUTH_HEADER_MODE" != "x-evento-api-key" && "$AUTH_HEADER_MODE" != "authorization" ]]; then
  echo "Invalid --auth-header value: $AUTH_HEADER_MODE"
  echo "Allowed values: x-evento-api-key, authorization"
  exit 1
fi
if [[ -z "$API_KEY" ]]; then
  PUBLIC_AUTH_HEADERS=()
  echo "No API key provided; public routes will be skipped unless --api-key is set."
else
  if [[ "$AUTH_HEADER_MODE" == "authorization" ]]; then
    PUBLIC_AUTH_HEADERS=("Authorization: Bearer $API_KEY")
  else
    PUBLIC_AUTH_HEADERS=("x-evento-api-key: $API_KEY")
  fi
fi
run_request() {
  local label="$1"
  local method="$2"
  local url="$3"
  local needs_auth="$4"
  printf "\n== %s ==\n" "$label"
  echo "${method} ${url}"
  local tmp_body
  tmp_body="$(mktemp)"
  local curl_exit=0
  local status
  if [[ "$needs_auth" == "1" && ${#PUBLIC_AUTH_HEADERS[@]} -eq 0 ]]; then
    echo "SKIPPED: missing API key"
    rm -f "$tmp_body"
    return 0
  fi
  set +e
  if [[ "$needs_auth" == "1" ]]; then
    status=$(curl -sS -X "$method" -H "${PUBLIC_AUTH_HEADERS[0]}" -o "$tmp_body" -w "%{http_code}" "$url")
  else
    status=$(curl -sS -X "$method" -o "$tmp_body" -w "%{http_code}" "$url")
  fi
  curl_exit=$?
  set -e
  if [[ $curl_exit -ne 0 ]]; then
    echo "curl failed (exit=$curl_exit)"
    rm -f "$tmp_body"
    return 0
  fi
  echo "HTTP $status"
  if command -v jq >/dev/null 2>&1; then
    if ! jq_output=$(jq . "$tmp_body" 2>/dev/null); then
      cat "$tmp_body"
    else
      printf '%s\n' "$jq_output"
    fi
  else
    cat "$tmp_body"
  fi
  rm -f "$tmp_body"
}
echo "Using base URL: $BASE_URL"
echo "Public API auth header mode: $AUTH_HEADER_MODE"
BASE_PUBLIC="$BASE_URL/api/public/v1"
BASE_EMBED="$BASE_URL/api/embed/v1"
run_request "Public: GET event" "GET" "$BASE_PUBLIC/events/$EVENT_ID" 1
run_request "Public: GET event guests" "GET" "$BASE_PUBLIC/events/$EVENT_ID/guests?limit=5&offset=0&status=all" 1
run_request "Public: GET user events" "GET" "$BASE_PUBLIC/users/$USERNAME/events?type=upcoming&limit=10&offset=0" 1
run_request "Embed: GET embed event" "GET" "$BASE_EMBED/events/$EVENT_ID" 0
run_request "Embed: GET embed user events" "GET" "$BASE_EMBED/users/$USERNAME/events?limit=10" 0
