Please support these services by visiting the websites for more content. [pluto.tv](https://pluto.tv/us/hub/home), [plex](https://www.plex.tv), [samsungtvplus](https://www.samsungtvplus.com), etc.

# ⭐ Free Service M3U Playlist Scaper

This repository automatically generates M3U playlist files for various free ad-supported streaming television (FAST) services using a Python script and GitHub Actions. The playlists include embedded EPG (Electronic Program Guide) information via the `url-tvg` tag in the M3U header.

## ▶️ How It Works

This is a custom set of scripts that are used to pull various sources and combine them into a single playlist.

## ▶️ Services Included

This generator currently creates playlists for

*   **Pluto TV US** = ( `plutotv_us.m3u` )

*   **Plex TV US**  = ( `plexs_us.m3u` )
    
*   **Samsung TV Plus**  = ( `samsungtvplus_us.m3u` )

*   **TVPass** (`tvpass.m3u`)
*   **MoveOnJoy** (`us_moveonjoy.m3u`) 

###   **EPG is NOT provided**
*   You will need another server such as m3u4u.com to manipulate the EPG TVG_ID to match your source.
*   They also provide a limited EPG source, but if you search around there are better sources.

**Example URL:**

*   **Free4JB Combo:** `https://raw.githubusercontent.com/4jb/iptv-combo/refs/heads/main/free4jb.m3u`

## ▶️ How to Use

The generated M3U file can be found in the [`/`](https://github.com/4jb/iptv-combo/tree/main) directory of this repository.

You can use this playlist in any IPTV player application that supports M3U playlists with remote URLs (e.g., TiviMate, IPTV Smarters, VLC, Kodi PVR IPTV Simple Client, OTT Navigator, etc.).

**To get the URL for a specific playlist:**

1.  Navigate to the [`/`](https://github.com/4jb/iptv-combo/tree/main) directory.
2.  Click on the `free4jb.m3u` file.
3.  On the file page, click the **"Raw"** button.
4.  Copy the URL from your browser's address bar.
   
## OR

Copy this url and add the playlist you want:
https://raw.githubusercontent.com/4jb/iptv-combo/main/free4jb.m3u

Paste this complete raw URL into your IPTV player's M3U playlist source field. The player should automatically fetch the playlist and the EPG data specified in the `url-tvg` tag.

## ▶️ Update Schedule

Playlists are automatically checked for updates daily via the GitHub Action workflow (around 08:00 UTC). Your IPTV player should periodically refresh the playlist URL to get the latest channel updates automatically if they have been committed.

## ▶️ Disclaimer

*   This repository merely aggregates publicly available channel information and stream URLs from the upstream sources mentioned.
*   The availability, legality, and stability of the streams themselves depend entirely on the original service providers and the upstream data sources. Streams may stop working, change format, or be removed without notice.
*   Ensure your use of these streams complies with the terms of service of the respective platforms and any applicable laws in your region.
*   The EPG data is also provided by the upstream sources and its accuracy is not guaranteed.
