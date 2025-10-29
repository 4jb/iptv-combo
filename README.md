Please support these services by visiting the websites for more content. [pluto.tv](https://pluto.tv/us/hub/home), [plex](https://www.plex.tv), [samsungtvplus](https://www.samsungtvplus.com), etc.

# ⭐ Free Service M3U Playlist Scaper

This repository automatically generates M3U playlist files for various free ad-supported streaming television (FAST) services using a Python script and GitHub Actions. The playlists include embedded EPG (Electronic Program Guide) information via the `url-tvg` tag in the M3U header.

## ▶️ How It Works

This is a custom set of scripts that are used to pull various free TV sources and combine them into a single playlist. This playlist is then processed locally to clean up files, appends source details on each channel name. This merged playlist is then pushed through an external m3u manager (https://m3u4u.com/) to automatically filter unwanted channels, rearrange all categories, adjust tvg-ids, as well as rename channels according to personal preference. This file is then stored on Github along with the EPG XML file.

## ▶️ Services Included

This generator currently creates playlists for

*   **Pluto TV US** = ( `plutotv_us.m3u` )

*   **Plex TV US**  = ( `plexs_us.m3u` )
    
*   **Samsung TV Plus**  = ( `samsungtvplus_us.m3u` )

*   **TVPass** (`tvpass.m3u`)
  
*   **MoveOnJoy** (`us_moveonjoy.m3u`) 

###   **Limited EPG is available**
*   This repository does provide an EPG provide by m3u4u specific for the `freetv.m3u` playlist.
*   The guide will be incomplete and the channels provided are likely to contain some issues.
*   You can certainly use another guide, but keep in mind that you will need another server, such as m3u4u.com, to manipulate the EPG TVG_ID to match your source.
*   If you are handy with scripts you can automate pulling guide data for every desired channel from zap2it and/or schedules direct. 

## ▶️ How to Use

The generated M3U files can be found in the [`/`](https://github.com/4jb/iptv-combo/tree/main) directory of this repository.

You can use these playlist in any IPTV player application that supports M3U playlists with remote URLs (e.g., TiviMate, IPTV Smarters, VLC, Kodi PVR IPTV Simple Client, OTT Navigator, etc.).

**To get the URL for a specific playlist:**

1.  Navigate to the [`/`](https://github.com/4jb/iptv-combo/tree/main) directory.
2.  Click on the `freetv.m3u` file.
3.  On the file page, click the **"Raw"** button.
4.  Copy the URL from your browser's address bar.
   
## OR

Copy this url and add the playlist you want:

# Customized Playlist `(Modified / Filtered / Sorted)`
https://raw.githubusercontent.com/4jb/iptv-combo/main/freetv.m3u

# Merged Playlist `(Unmodified / Unfiltered / Unsorted)`
https://raw.githubusercontent.com/4jb/iptv-combo/main/freetv-merged.m3u

Paste this complete raw URL into your IPTV player's M3U playlist source field. The player should automatically fetch the playlist and the EPG data specified in the `url-tvg` tag.

**Example URL:**

*   **Customized FreeTV:** `https://raw.githubusercontent.com/4jb/iptv-combo/refs/heads/main/freetv.m3u`
*   **Merged FreeTV:** `https://raw.githubusercontent.com/4jb/iptv-combo/refs/heads/main/freetv-merged.m3u`

## ▶️ Update Schedule

Playlists are automatically checked for updates daily via the GitHub Action workflow (around 08:00 UTC). Your IPTV player should periodically refresh the playlist URL to get the latest channel updates automatically if they have been committed.

## ▶️ Disclaimer

*   This repository merely aggregates publicly available channel information and stream URLs from the upstream sources mentioned.
*   The availability, legality, and stability of the streams themselves depend entirely on the original service providers and the upstream data sources. Streams may stop working, change format, or be removed without notice.
*   Ensure your use of these streams complies with the terms of service of the respective platforms and any applicable laws in your region.
*   The EPG data is also provided by the upstream sources and its accuracy is not guaranteed.
