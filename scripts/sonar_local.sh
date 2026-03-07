#!/usr/bin/env bash
# =============================================================================
# scripts/sonar_local.sh — Run SonarQube analysis locally before committing
# =============================================================================
#
# Prerequisites:
#   1. Install sonar-scanner:  brew install sonar-scanner
#   2. Export environment variables:
#        export SONAR_TOKEN="<your-sonarcloud-token>"
#        export SONAR_HOST_URL="https://sonarcloud.io"   # or your self-hosted URL
#
# Usage:
#   bash scripts/sonar_local.sh
#
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ---------------------------------------------------------------------------
# 1. Validate required env vars
# ---------------------------------------------------------------------------
if [[ -z "${SONAR_TOKEN:-}" ]]; then
  echo "❌ SONAR_TOKEN is not set. Export it first:"
  echo "     export SONAR_TOKEN=<your-sonarcloud-token>"
  exit 1
fi

if [[ -z "${SONAR_HOST_URL:-}" ]]; then
  echo "ℹ️  SONAR_HOST_URL not set — defaulting to https://sonarcloud.io"
  export SONAR_HOST_URL="https://sonarcloud.io"
fi

# ---------------------------------------------------------------------------
# 2. Run Flutter tests with coverage
# ---------------------------------------------------------------------------
echo ""
echo "🧪 Running Flutter tests with coverage..."
cd "$PROJECT_ROOT"
flutter test --coverage

echo ""
echo "✅ Coverage report generated at coverage/lcov.info"

# ---------------------------------------------------------------------------
# 3. Run sonar-scanner
# ---------------------------------------------------------------------------
echo ""
echo "🔍 Running SonarQube scanner..."
sonar-scanner \
  -Dsonar.host.url="${SONAR_HOST_URL}" \
  -Dsonar.token="${SONAR_TOKEN}"

echo ""
echo "✅ SonarQube scan complete!"
echo "   View results at: ${SONAR_HOST_URL}/dashboard?id=stockswipe"
