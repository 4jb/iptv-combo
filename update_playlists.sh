#!/bin/bash
# =====================================
# IPTV Playlist Aggregator & Uploader
# =====================================
# Combines multiple M3U playlists (from URL list file),
# removes duplicates, sorts alphabetically,
# rotates 7 daily backups, and pushes to GitHub
# only if changes exist.
#
# Example cron job (every 6 hours):
# 0 */6 * * * /path/to/update_playlists.sh >> /path/to/update_playlists.log 2>&1
# =====================================

# === CONFIGURATION ===
WORKDIR="/usr/iptv-combo"       # Local clone of your GitHub repo
OUTPUT_FILE="free4jb.m3u"          # Final merged playlist name
URL_LIST_FILE="$WORKDIR/playlists"  # Text file with one URL per line
GITHUB_REMOTE="origin"
GITHUB_BRANCH="main"

# === SCRIPT START ===
set -e
cd "$WORKDIR" || { echo "❌ Repo path not found: $WORKDIR"; exit 1; }

if [[ ! -f "$URL_LIST_FILE" ]]; then
  echo "❌ URL list file not found: $URL_LIST_FILE"
  exit 1
fi

TEMP_FILE="$(mktemp)"
MERGED_FILE="$(mktemp)"
SORTED_FILE="$(mktemp)"
DAY_OF_WEEK=$(date +%a)
BACKUP_FILE="backup/${OUTPUT_FILE}.${DAY_OF_WEEK}"

echo "#EXTM3U" > "$TEMP_FILE"

echo "🔄 Fetching and merging playlists from $URL_LIST_FILE..."
while IFS= read -r URL; do
  [[ -z "$URL" || "$URL" =~ ^# ]] && continue  # skip blank lines or comments
  echo "  ➤ Fetching $URL ..."
  curl -fsSL "$URL" | grep -v '^#EXTM3U' >> "$TEMP_FILE" || echo "⚠️ Failed to fetch $URL"
done < "$URL_LIST_FILE"
echo "✅ Merged playlists into temporary file."

mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "✅ Combined playlist saved to $OUTPUT_FILE"

# === BACKUP ROTATION ===
if [[ -f "$OUTPUT_FILE" ]]; then
  cp "$OUTPUT_FILE" "$BACKUP_FILE"
  echo "💾 Backed up previous version to $BACKUP_FILE"
fi

echo "✅ Final playlist saved to $OUTPUT_FILE"

# === GIT OPERATIONS ===
echo "🚀 Updating GitHub repo..."
git pull --rebase "$GITHUB_REMOTE" "$GITHUB_BRANCH"
git add "$OUTPUT_FILE" "$BACKUP_FILE" || true
git commit -m "Auto-update IPTV playlist ($(date '+%Y-%m-%d %H:%M:%S'))" || echo "No changes to commit"
git push "$GITHUB_REMOTE" "$GITHUB_BRANCH"

# === CLEANUP ===
rm -f "$TEMP_FILE" "$MERGED_FILE" "$SORTED_FILE"

echo "🎉 Update complete at $(date)"
