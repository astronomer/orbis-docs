#!/usr/bin/env bash
# Syncs customer-facing docs from the orbis repo to orbis-docs.
# Usage: ./scripts/sync-docs.sh /path/to/orbis
set -euo pipefail

ORBIS_DIR="${1:?Usage: $0 /path/to/orbis}"
DOCS_SRC="$ORBIS_DIR/docs"
DOCS_DST="$(git rev-parse --show-toplevel)/docs"

if [[ ! -f "$ORBIS_DIR/mkdocs-external.yaml" ]]; then
  echo "ERROR: $ORBIS_DIR does not appear to be the orbis repo" >&2
  exit 1
fi

# Directories to copy (customer-facing only)
COPY_DIRS=(get-started reporting scanner assets)
COPY_FILES=(index.md changelog.md)
PRUNE_DIRS=(development reference legacy modules usage)
PRUNE_FILES=(installation.md reports.md reporting/kubernetes-pod-metrics.md)

# Clean destination directories
for dir in "${COPY_DIRS[@]}"; do
  rm -rf "$DOCS_DST/$dir"
done
for dir in "${PRUNE_DIRS[@]}"; do
  rm -rf "$DOCS_DST/$dir"
done
for f in "${COPY_FILES[@]}"; do
  rm -f "$DOCS_DST/$f"
done
for f in "${PRUNE_FILES[@]}"; do
  rm -f "$DOCS_DST/$f"
done

# Copy external-facing content
for dir in "${COPY_DIRS[@]}"; do
  if [[ ! -d "$DOCS_SRC/$dir" ]]; then
    echo "ERROR: missing source directory: $DOCS_SRC/$dir" >&2
    exit 1
  fi
  cp -R "$DOCS_SRC/$dir" "$DOCS_DST/$dir"
done
for f in "${COPY_FILES[@]}"; do
  if [[ ! -f "$DOCS_SRC/$f" ]]; then
    echo "ERROR: missing source file: $DOCS_SRC/$f" >&2
    exit 1
  fi
  cp "$DOCS_SRC/$f" "$DOCS_DST/$f"
done

OVERRIDES="$(git rev-parse --show-toplevel)/docs-overrides"
if [[ "${APPLY_DOCS_OVERRIDES:-false}" == "true" && -d "$OVERRIDES" ]]; then
  echo "Applying customer-facing overrides from docs-overrides/ because APPLY_DOCS_OVERRIDES=true..."
  cp -R "$OVERRIDES/"* "$DOCS_DST/"
  echo "  Overrides applied"
else
  echo "Skipping docs-overrides/. Set APPLY_DOCS_OVERRIDES=true to apply them."
fi

echo ""
echo "Sync complete: $DOCS_SRC -> $DOCS_DST"
echo "Copied: ${COPY_DIRS[*]} ${COPY_FILES[*]}"
echo "Excluded: ${PRUNE_DIRS[*]}"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Test locally: python -m mkdocs serve -f mkdocs.yaml"
echo "  3. Commit and push"
