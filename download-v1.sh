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
DOWNLOAD_FOLDER="$WORKDIR/downloads"          # Final merged playlist name
URL_LIST_FILE="$WORKDIR/playlists"  # Text file with one URL per line

# === SCRIPT START ===
set -e
cd "$WORKDIR" || { echo "▒^}^l Repo path not found: $WORKDIR"; exit 1; }

if [[ ! -f "$URL_LIST_FILE" ]]; then
  echo "▒^}^l URL list file not found: $URL_LIST_FILE"
  exit 1
fi

if [[ ! -d "$DOWNLOAD_FOLDER" ]]; then
  echo "▒^}^l Downloads Folder not found: $DOWNLOAD_FOLDER"
  exit 1
fi

echo "▒^=^t^d Fetching playlists from $URL_LIST_FILE..."
grep -Ev "^#|^$" $URL_LIST_FILE | wget -i - -P $DOWNLOAD_FOLDER -c -nv
echo "▒^|^e Downloaded playlists into $DOWNLOAD_FOLDER folder."

echo "Renaming Playlists..."
mv $DOWNLOAD_FOLDER/m3u $DOWNLOAD_FOLDER/TVPass.m3u
mv $DOWNLOAD_FOLDER/samsungtvplus_us.m3u $DOWNLOAD_FOLDER/Samsung.m3u
mv $DOWNLOAD_FOLDER/plutotv_us.m3u $DOWNLOAD_FOLDER/PlutoTV.m3u
mv $DOWNLOAD_FOLDER/plex_us.m3u $DOWNLOAD_FOLDER/PlexTV.m3u
mv $DOWNLOAD_FOLDER/us_moveonjoy.m3u $DOWNLOAD_FOLDER/MoveOnJoy.m3u

echo "Done."
