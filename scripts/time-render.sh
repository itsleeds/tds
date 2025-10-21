#!/usr/bin/env bash
set -euo pipefail

# Simple timing script for Quarto .qmd files using the 'timing' profile.
# Usage: ./scripts/time-render.sh [file1.qmd file2.qmd ...]
# If no files are given, it will time a small default set (index.qmd and s*/index.qmd).

OUT_DIR="/tmp/tds_timing"
RESULT_CSV="$(pwd)/scripts/timing-results.csv"
PROFILE="timing"

mkdir -p "${OUT_DIR}"

if [ "$#" -eq 0 ]; then
  # Default targets: top-level index and session indexes
  FILES=(index.qmd s*/index.qmd)
else
  FILES=("$@")
fi

echo "file,start_ts,end_ts,duration_seconds,exit_code,log" > "${RESULT_CSV}"

for f in ${FILES[@]}; do
  # Skip if glob didn't match
  if [ ! -e "$f" ]; then
    echo "Skipping missing file: $f"
    continue
  fi

  base=$(basename "$f" .qmd)
  ts_start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  logfile="${OUT_DIR}/${base}-$(date -u +%Y%m%dT%H%M%SZ).log"

  echo "Rendering $f (log: $logfile)"

  # Measure time with /usr/bin/time for real elapsed seconds
  # Use a subshell to capture exit code
  { /usr/bin/time -f "%e" -o /tmp/tds_time_val.txt quarto render --profile ${PROFILE} "$f" &> "$logfile"; rc=$?; echo $rc > /tmp/tds_time_rc.txt; } || true

  duration=$(cat /tmp/tds_time_val.txt 2>/dev/null || echo "")
  rc=$(cat /tmp/tds_time_rc.txt 2>/dev/null || echo "1")
  ts_end=$(date -u +%Y-%m-%dT%H:%M:%SZ)

  # Write a single-line CSV-safe entry (escape quotes in logfile path)
  echo "${f},${ts_start},${ts_end},${duration},${rc},${logfile}" >> "${RESULT_CSV}"

  echo "Finished $f -> duration=${duration}s rc=${rc}"
done

echo "Results written to ${RESULT_CSV} and logs in ${OUT_DIR}"
#!/usr/bin/env bash
set -euo pipefail

# Time the render of .qmd files with a Quarto timing profile.
# This forces real execution (no freeze/cache) so durations reflect true cost.
#
# Usage examples:
#   scripts/time-render.sh              # auto-detect top-level *.qmd and s*/index.qmd
#   scripts/time-render.sh index.qmd s1/index.qmd s2/index.qmd
#
# Requires: quarto, bash, GNU date (Linux) or coreutils gdate (macOS with coreutils)

RED="\033[0;31m"; GREEN="\033[0;32m"; YELLOW="\033[0;33m"; NC="\033[0m"

has_quarto() {
  command -v quarto >/dev/null 2>&1
}

timestamp() {
  # Portable timestamp in seconds since epoch
  date +%s
}

if ! has_quarto; then
  echo -e "${RED}Error:${NC} quarto not found in PATH. Install Quarto and retry." >&2
  exit 1
fi

# Gather files
FILES=("$@")
if [ ${#FILES[@]} -eq 0 ]; then
  # Common docs: site index and per-session index pages
  mapfile -t TOP_LEVEL < <(ls -1 *.qmd 2>/dev/null || true)
  mapfile -t SESSIONS < <(ls -1 s*/index.qmd 2>/dev/null || true)
  mapfile -t DOCS < <(ls -1 d*/index.qmd 2>/dev/null || true)
  mapfile -t SEMS < <(ls -1 sem*/index.qmd 2>/dev/null || true)
  FILES=(${TOP_LEVEL[@]:-} ${SESSIONS[@]:-} ${DOCS[@]:-} ${SEMS[@]:-})
fi

if [ ${#FILES[@]} -eq 0 ]; then
  echo -e "${YELLOW}No .qmd files found to time.${NC}" >&2
  exit 0
fi

printf "Timing %d document(s) with '--profile timing' (no cache, no freeze)\n" "${#FILES[@]}"

declare -A DURATIONS
FAILED=()

for f in "${FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo -e "${YELLOW}Skip (missing):${NC} $f"
    continue
  fi
  echo -e "\n${YELLOW}Rendering:${NC} $f"
  start=$(timestamp)
  if quarto render --profile timing "$f" >/dev/null 2>&1; then
    end=$(timestamp)
    dur=$(( end - start ))
    DURATIONS["$f"]=$dur
    printf "${GREEN}OK${NC} %s took %ds\n" "$f" "$dur"
  else
    echo -e "${RED}FAIL${NC} $f"
    FAILED+=("$f")
  fi
done

echo -e "\n==== Summary (slowest first) ===="
# Print durations sorted descending
for k in "${!DURATIONS[@]}"; do echo -e "${DURATIONS[$k]}\t$k"; done | sort -nr | awk '{printf "%4ds  %s\n", $1, $2}'

if [ ${#FAILED[@]} -gt 0 ]; then
  echo -e "\n${RED}Failures:${NC} ${FAILED[*]}"
  exit 1
fi

echo -e "\nTip: consider using the optional CI profile to disable eval for the single slowest doc during CI only."
