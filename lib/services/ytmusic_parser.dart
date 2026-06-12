import 'package:flutter/foundation.dart';

import '../data/models/song.dart';
import '../data/models/home_section.dart';
import '../data/models/artist.dart';
import '../data/models/playlist.dart';

/// Minimal YouTube Music InnerTube JSON parser for Pulse.
class YtMusicParser {
  static String? _getText(dynamic node) {
    if (node == null) return null;
    if (node is String) return node;
    if (node['text'] != null) return node['text'];
    if (node['runs'] != null && node['runs'].isNotEmpty) {
      return node['runs'].map((r) => r['text'] ?? '').join('');
    }
    return null;
  }

  static String _extractThumb(dynamic node) {
    if (node == null) return '';
    try {
      final thumbs = node['thumbnails'] ?? 
                     node['thumbnail']?['thumbnails'] ?? 
                     node['thumbnailRenderer']?['musicThumbnailRenderer']?['thumbnail']?['thumbnails'] ??
                     node['thumbnail']?['musicThumbnailRenderer']?['thumbnail']?['thumbnails'] ?? 
                     node['musicThumbnailRenderer']?['thumbnail']?['thumbnails'] ?? [];
      if (thumbs.isEmpty) return '';
      final thumbsList = List<dynamic>.from(thumbs);
      thumbsList.sort((a, b) => ((b['width'] as int? ?? 0).compareTo(a['width'] as int? ?? 0)));
      var url = thumbsList.first['url']?.toString() ?? '';
      if (url.startsWith('//')) url = 'https:$url';
      return url.replaceAll('http://', 'https://');
    } catch (e, stack) {
      debugPrint('THUMB ERROR: $e\n$stack');
      return '';
    }
  }

  static Song? _parseResponsiveListItem(dynamic item) {
    try {
      final renderer = item['musicResponsiveListItemRenderer'];
      if (renderer == null) return null;

      final flexColumns = renderer['flexColumns'] ?? [];
      if (flexColumns.isEmpty) return null;

      final titleNode = flexColumns[0]?['musicResponsiveListItemFlexColumnRenderer']?['text']?['runs']?[0];
      final title = _getText(titleNode) ?? 'Unknown';
      
      // Extract videoId — YouTube uses multiple JSON structures depending on
      // context (playlist items, search results, watch-next, etc.)
      final videoId = renderer['playlistItemData']?['videoId'] ?? 
                      titleNode?['navigationEndpoint']?['watchEndpoint']?['videoId'] ??
                      renderer['overlay']?['musicItemThumbnailOverlayRenderer']
                          ?['content']?['musicPlayButtonRenderer']
                          ?['playNavigationEndpoint']?['watchEndpoint']?['videoId'] ??
                      (renderer['flexColumnDisplayStyle'] != null 
                          ? _extractVideoIdFromFlexColumns(flexColumns) 
                          : null);
      
      final browseId = titleNode?['navigationEndpoint']?['browseEndpoint']?['browseId'] ??
                       renderer['navigationEndpoint']?['browseEndpoint']?['browseId'];
      
      String artist = 'Unknown';
      String album = '';
      String artistBrowseId = '';
      String? albumBrowseId;
      
      if (flexColumns.length > 1) {
        final subRuns = flexColumns[1]?['musicResponsiveListItemFlexColumnRenderer']?['text']?['runs'] as List? ?? [];
        if (subRuns.isNotEmpty) {
          int partIndex = 0;
          bool hasTypePrefix = false;
          
          String parsedArtist = '';
          String? parsedArtistId;
          String parsedAlbum = '';
          String? parsedAlbumId;

          for (final run in subRuns) {
            final text = _getText(run) ?? '';
            if (text == ' • ' || text.toLowerCase().contains('youtube music')) {
              if (text == ' • ') partIndex++;
              continue;
            }
            
            if (partIndex == 0 && (text == 'Song' || text == 'Video')) {
              hasTypePrefix = true;
              continue;
            }
            
            int effectivePart = hasTypePrefix ? partIndex - 1 : partIndex;
            final nav = run['navigationEndpoint'];
            final rBrowseId = nav?['browseEndpoint']?['browseId']?.toString();
            
            if (effectivePart == 0) {
               parsedArtist += text;
               if (rBrowseId != null && parsedArtistId == null) parsedArtistId = rBrowseId;
            } else if (effectivePart == 1) {
               // Only accept album if it's not a duration or year
               if (!RegExp(r'^\d+:\d+$').hasMatch(text) && !RegExp(r'^\d{4}$').hasMatch(text) && !text.toLowerCase().contains('views')) {
                  parsedAlbum += text;
                  if (rBrowseId != null && parsedAlbumId == null) parsedAlbumId = rBrowseId;
               }
            }
          }
          
          if (parsedArtist.isNotEmpty) artist = parsedArtist;
          if (parsedArtistId != null) artistBrowseId = parsedArtistId;
          if (parsedAlbum.isNotEmpty) album = parsedAlbum;
          if (parsedAlbumId != null) albumBrowseId = parsedAlbumId;
        }
      }

      final type = videoId != null ? 'SONG' 
                 : browseId != null && browseId.startsWith('UC') ? 'ARTIST' 
                 : 'PLAYLIST';

      return Song(
        id: videoId ?? browseId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        videoId: videoId ?? '',
        title: title,
        artist: artist,
        album: album,
        thumbnail: _extractThumb(renderer),
        browseId: browseId,
        artistBrowseId: artistBrowseId.isNotEmpty ? artistBrowseId : null,
        albumBrowseId: albumBrowseId,
        type: type,
      );
    } catch (_) {
      return null;
    }
  }

  /// Fallback: scan flexColumns runs for any watchEndpoint videoId.
  static String? _extractVideoIdFromFlexColumns(List<dynamic> flexColumns) {
    for (final col in flexColumns) {
      final runs = col?['musicResponsiveListItemFlexColumnRenderer']?['text']?['runs'] as List?;
      if (runs == null) continue;
      for (final run in runs) {
        final vid = run?['navigationEndpoint']?['watchEndpoint']?['videoId'];
        if (vid != null && vid.toString().length == 11) return vid.toString();
      }
    }
    return null;
  }

  static List<HomeSection> parseHomeFeed(Map<String, dynamic> data) {
    final sections = <HomeSection>[];
    try {
      List<dynamic> tabContent = [];

      final singleCol = data['contents']?['singleColumnBrowseResultsRenderer']?['tabs'];
      if (singleCol is List && singleCol.isNotEmpty) {
        tabContent = singleCol[0]?['tabRenderer']?['content']
            ?['sectionListRenderer']?['contents'] ?? [];
      }

      if (tabContent.isEmpty) {
        final twoCol = data['contents']?['twoColumnBrowseResultsRenderer'];
        if (twoCol != null) {
          tabContent = twoCol['tabs']?[0]?['tabRenderer']?['content']
              ?['sectionListRenderer']?['contents'] ?? [];
        }
      }

      for (final section in tabContent) {
        sections.addAll(_parseShelves(section as Map<String, dynamic>));
      }
    } catch (e) {
      debugPrint('[YtMusicParser] parseHomeFeed error: $e');
    }
    return sections;
  }

  /// Extracts the continuation token from a home feed or continuation response.
  static String? extractHomeContinuation(Map<String, dynamic> data) {
    try {
      // From initial browse response
      final sc = data['contents']?['singleColumnBrowseResultsRenderer'];
      if (sc != null) {
        final conts = sc['tabs']?[0]?['tabRenderer']?['content']
            ?['sectionListRenderer']?['continuations'] as List?;
        return conts?[0]?['nextContinuationData']?['continuation'] as String?;
      }
      // From a continuation response
      final contContents = data['continuationContents']?['sectionListContinuation'];
      if (contContents != null) {
        final conts = contContents['continuations'] as List?;
        return conts?[0]?['nextContinuationData']?['continuation'] as String?;
      }
    } catch (_) {}
    return null;
  }

  /// Helper to extract continuation from a contents array's last item
  static String? _extractContinuationFromContents(List<dynamic>? contents) {
    if (contents == null || contents.isEmpty) return null;
    final lastItem = contents.last;
    if (lastItem is Map && lastItem.containsKey('continuationItemRenderer')) {
      final renderer = lastItem['continuationItemRenderer'];
      return renderer?['continuationEndpoint']?['continuationCommand']?['token'] as String?;
    }
    return null;
  }

  /// Extracts the continuation token from a playlist or playlist continuation response.
  static String? extractPlaylistContinuation(Map<String, dynamic> data) {
    return _findContinuation(data);
  }

  static String? _findContinuation(dynamic obj) {
    if (obj is Map) {
      if (obj.containsKey('nextContinuationData')) {
        return obj['nextContinuationData']?['continuation'] as String?;
      }
      if (obj.containsKey('continuationCommand')) {
        return obj['continuationCommand']?['token'] as String?;
      }
      if (obj.containsKey('continuationItemRenderer')) {
        return obj['continuationItemRenderer']?['continuationEndpoint']?['continuationCommand']?['token'] as String?;
      }
      for (final value in obj.values) {
        final res = _findContinuation(value);
        if (res != null) return res;
      }
    } else if (obj is List) {
      for (final item in obj) {
        final res = _findContinuation(item);
        if (res != null) return res;
      }
    }
    return null;
  }

  /// Parses sections from a continuation response payload.
  static List<HomeSection> parseHomeContinuation(Map<String, dynamic> data) {
    final sections = <HomeSection>[];
    try {
      final contents = (data['continuationContents']?['sectionListContinuation']
          ?['contents'] as List?) ?? [];
      for (var section in contents) {
        sections.addAll(_parseShelves(section));
      }
    } catch (e) {
      debugPrint('[YtMusicParser] parseHomeContinuation error: $e');
    }
    return sections;
  }

  /// Shared helper — parse carousel or shelf from a section map.
  static List<HomeSection> _parseShelves(Map<String, dynamic> section) {
    final out = <HomeSection>[];
    final carousel = section['musicCarouselShelfRenderer'] ?? section['musicImmersiveCarouselShelfRenderer'];
    final shelf = section['musicShelfRenderer'];

    if (carousel != null) {
      final headerNode = carousel['header']?['musicCarouselShelfBasicHeaderRenderer']?['title'];
      final title = _getText(headerNode) ?? 'Recommended';
      final items = carousel['contents'] as List? ?? [];
      final parsedItems = <Song>[];
      for (final i in items) {
        if (i['musicTwoRowItemRenderer'] != null) {
          final renderer = i['musicTwoRowItemRenderer'];
          var videoId = renderer['navigationEndpoint']?['watchEndpoint']?['videoId'];
          videoId ??= renderer['thumbnailOverlay']?['musicItemThumbnailOverlayRenderer']
              ?['content']?['musicPlayButtonRenderer']
              ?['playNavigationEndpoint']?['watchEndpoint']?['videoId'];
          final browseId = renderer['navigationEndpoint']?['browseEndpoint']?['browseId'];
          // Parse subtitle runs to extract clean artist name + browse IDs.
          // Subtitle runs look like: ["Song", " • ", "Arijit Singh"(+browse), " • ", "Album"(+browse), " • ", "3:45"]
          // We must NOT just join all runs — that produces dirty "Song • Arijit Singh • 3:45" strings.
          String artist = '';
          String? artistBrowseId;
          String? albumBrowseId;
          final subRuns = renderer['subtitle']?['runs'] as List? ?? [];
          int partIdx = 0;
          bool hasTypePrefix = false;
          for (final run in subRuns) {
            final text = (run['text'] as String? ?? '').trim();
            if (text == '•' || text == ' • ') { partIdx++; continue; }
            final runBrowse = run['navigationEndpoint']?['browseEndpoint']?['browseId']?.toString();
            if (partIdx == 0 && (text == 'Song' || text == 'Video' || text == 'Playlist')) {
              hasTypePrefix = true; continue;
            }
            final eff = hasTypePrefix ? partIdx - 1 : partIdx;
            if (eff == 0) {
              // Artist part
              if (text.isNotEmpty) artist += (artist.isEmpty ? '' : ' ') + text;
              if (runBrowse != null && artistBrowseId == null) artistBrowseId = runBrowse;
            } else if (eff == 1) {
              // Album part — skip durations and years
              if (!RegExp(r'^\d+:\d+$').hasMatch(text) && !RegExp(r'^\d{4}$').hasMatch(text)) {
                if (runBrowse != null && albumBrowseId == null) albumBrowseId = runBrowse;
              }
            }
          }
          parsedItems.add(Song(
            id: videoId ?? browseId ?? '',
            videoId: videoId ?? '',
            title: _getText(renderer['title']) ?? '',
            artist: artist.isNotEmpty ? artist : (_getText(renderer['subtitle']) ?? ''),
            thumbnail: _extractThumb(renderer),
            browseId: browseId,
            artistBrowseId: artistBrowseId,
            albumBrowseId: albumBrowseId,
            type: videoId != null ? 'SONG' : 'PLAYLIST',
          ));
        } else {
          final song = _parseResponsiveListItem(i);
          if (song != null) parsedItems.add(song);
        }
      }
      if (parsedItems.isNotEmpty) out.add(HomeSection(title: title, items: parsedItems));
    } else if (shelf != null) {
      final title = _getText(shelf['title']) ?? 'Recommended';
      final items = shelf['contents'] as List? ?? [];
      final parsedItems = <Song>[];
      for (final i in items) {
        final song = _parseResponsiveListItem(i);
        if (song != null) parsedItems.add(song);
      }
      if (parsedItems.isNotEmpty) out.add(HomeSection(title: title, items: parsedItems));
    }
    return out;
  }

  static List<Song> parseSearch(Map<String, dynamic> data, String type) {
    final results = <Song>[];
    try {
      final contents = data['contents']?['tabbedSearchResultsRenderer']?['tabs']?[0]?['tabRenderer']?['content']?['sectionListRenderer']?['contents'] ?? [];
      for (var section in contents) {
        final items = section['musicShelfRenderer']?['contents'] ?? [];
        for (var item in items) {
          final song = _parseResponsiveListItem(item);
          if (song != null) results.add(song);
        }
      }
    } catch (e) {
      debugPrint('[YtMusicParser] parseSearch error: $e');
    }
    return results;
  }

  static List<String> parseSearchSuggestions(Map<String, dynamic> data) {
    final results = <String>[];
    try {
      final contents = data['contents']?[0]?['searchSuggestionsSectionRenderer']?['contents'] ?? [];
      for (var item in contents) {
        final suggestion = item['searchSuggestionRenderer']?['suggestion'];
        final text = _getText(suggestion);
        if (text != null && text.isNotEmpty) {
          results.add(text);
        }
      }
    } catch (e) {
      debugPrint('[YtMusicParser] parseSearchSuggestions error: $e');
    }
    return results;
  }

  static Playlist parsePlaylist(Map<String, dynamic> data, String id) {
    final tracks = <Song>[];
    String title = 'Playlist';
    String description = '';
    String thumbnail = '';

    try {
      // ── Title / thumbnail ──────────────────────────────────────────────────
      final header = data['header']?['musicResponsiveHeaderRenderer'] ??
                     data['header']?['musicDetailHeaderRenderer'] ??
                     data['header']?['musicImmersiveHeaderRenderer'];
      final microformat = data['microformat']?['microformatDataRenderer'];

      if (header != null) {
        title = _getText(header['title']) ?? title;
        description = _getText(header['description']) ?? description;
        thumbnail = _extractThumb(header);
      }
      if (microformat != null) {
        if (title == 'Playlist') title = microformat['title']?.toString() ?? title;
        if (description.isEmpty) description = microformat['description']?.toString() ?? description;
        if (thumbnail.isEmpty) thumbnail = _extractThumb(microformat);
      }

      // ── Extract tracks ─────────────────────────────────────────────────────
      List<dynamic> contents = [];

      // Path 1: singleColumnBrowseResultsRenderer (regular playlists – VL… IDs)
      final singleTabContent = data['contents']?['singleColumnBrowseResultsRenderer']
          ?['tabs']?[0]?['tabRenderer']?['content']?['sectionListRenderer']?['contents'];
      if (singleTabContent != null) {
        contents = List<dynamic>.from(singleTabContent);
      }

      // Path 2: twoColumnBrowseResultsRenderer (albums – MPRE… IDs)
      if (contents.isEmpty) {
        final twoCol = data['contents']?['twoColumnBrowseResultsRenderer'];
        if (twoCol != null) {
          // Tracks live in secondaryContents
          final secondary = twoCol['secondaryContents']?['sectionListRenderer']?['contents'];
          if (secondary != null) contents = List<dynamic>.from(secondary);

          // Try to get title/thumbnail from the primary tabs if still missing
          if (thumbnail.isEmpty || title == 'Playlist') {
            final primaryTabContent = twoCol['tabs']?[0]?['tabRenderer']?['content']
                ?['sectionListRenderer']?['contents'] as List?;
            if (primaryTabContent != null) {
              for (var sec in primaryTabContent) {
                final hdr = sec['musicEditablePlaylistDetailHeaderRenderer']
                    ?? sec['musicResponsiveHeaderRenderer'];
                if (hdr != null) {
                  if (title == 'Playlist') title = _getText(hdr['title']) ?? title;
                  if (thumbnail.isEmpty) thumbnail = _extractThumb(hdr);
                  break;
                }
              }
            }
          }
        }
      }

      // Path 3: Playlist continuation response
      if (contents.isEmpty) {
        _extractTracksRecursively(data, tracks);
      }

      for (var section in contents) {
        final items = (section['musicPlaylistShelfRenderer']?['contents'] ??
                       section['musicShelfRenderer']?['contents'] ?? []) as List;
        for (var item in items) {
          final song = _parseResponsiveListItem(item);
          if (song != null && song.videoId.isNotEmpty) tracks.add(song);
        }
      }

      // Last-resort fallback: borrow album name + art from first track
      if (title == 'Playlist' && thumbnail.isEmpty && tracks.isNotEmpty) {
        title = tracks.first.album.isNotEmpty ? tracks.first.album : 'Album';
        thumbnail = tracks.first.thumbnail;
      }
    } catch (e) {
      debugPrint('[YtMusicParser] parsePlaylist error: $e');
    }

    return Playlist(
      id: id,
      name: title,
      description: description,
      thumbnail: thumbnail,
      type: 'YTM_PLAYLIST',
      songs: tracks,
      totalTracks: tracks.length,
      createdBy: '',
    );
  }

  static void _extractTracksRecursively(dynamic obj, List<Song> tracks) {
    if (obj is Map) {
      if (obj.containsKey('musicResponsiveListItemRenderer')) {
        final song = _parseResponsiveListItem(obj);
        if (song != null && song.videoId.isNotEmpty) tracks.add(song);
      } else {
        for (final value in obj.values) {
          _extractTracksRecursively(value, tracks);
        }
      }
    } else if (obj is List) {
      for (final item in obj) {
        _extractTracksRecursively(item, tracks);
      }
    }
  }

  static Artist parseArtist(Map<String, dynamic> data, String browseId) {
    String name = 'Artist';
    String description = '';
    String thumbnail = '';
    final topSongs = <Song>[];
    final albums = <ArtistAlbum>[];

    try {
      final header = data['header']?['musicImmersiveHeaderRenderer'] ?? data['header']?['musicVisualHeaderRenderer'];
      name = _getText(header?['title']) ?? name;
      thumbnail = _extractThumb(header);

      final contents = data['contents']?['singleColumnBrowseResultsRenderer']?['tabs']?[0]?['tabRenderer']?['content']?['sectionListRenderer']?['contents'] ?? [];
      
      for (var section in contents) {
        final shelf = section['musicShelfRenderer'];
        final carousel = section['musicCarouselShelfRenderer'];
        
        if (shelf != null) {
          final title = _getText(shelf['title'])?.toLowerCase() ?? '';
          if (title.contains('song')) {
            for (var item in shelf['contents'] ?? []) {
              final song = _parseResponsiveListItem(item);
              if (song != null) topSongs.add(song);
            }
          }
        }
        
        if (carousel != null) {
          final headerText = _getText(carousel['header']?['musicCarouselShelfBasicHeaderRenderer']?['title'])?.toLowerCase() ?? '';
          if (headerText.contains('album') || headerText.contains('single')) {
            for (var i in carousel['contents'] ?? []) {
              final renderer = i['musicTwoRowItemRenderer'];
              if (renderer == null) continue;
              final bId = renderer['navigationEndpoint']?['browseEndpoint']?['browseId'];
              if (bId != null) {
                albums.add(ArtistAlbum(
                  browseId: bId,
                  title: _getText(renderer['title']) ?? '',
                  year: '',
                  thumbnail: _extractThumb(renderer),
                  type: 'ALBUM',
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[YtMusicParser] parseArtist error: $e');
    }

    return Artist(
      browseId: browseId,
      name: name,
      description: description,
      thumbnail: thumbnail,
      subscribers: '',
      topSongs: topSongs,
      albums: albums,
      singles: [],
    );
  }

  /// Parses the watch-next / radio queue from a direct Innertube `next` response.
  ///
  /// The JSON path differs between authenticated/unauthenticated and between
  /// proxy-normalized vs. raw Innertube responses. We try all known paths so
  /// that the queue works regardless of how the response arrives.
  static List<Song> parseWatchNext(Map<String, dynamic> data) {
    List<dynamic> contents = [];

    // Path 1: Standard WEB_REMIX watchNext (most common for unauthenticated)
    contents = data['contents']
            ?['singleColumnMusicWatchNextResultsRenderer']
            ?['tabbedRenderer']
            ?['watchNextTabbedResultsRenderer']
            ?['tabs']
            ?[0]
            ?['tabRenderer']
            ?['content']
            ?['musicQueueRenderer']
            ?['content']
            ?['playlistPanelRenderer']
            ?['contents'] ??
        [];

    // Path 2: Autoplay / radio panel (used when autoplay is active)
    if (contents.isEmpty) {
      contents = data['contents']
              ?['singleColumnMusicWatchNextResultsRenderer']
              ?['autoplay']
              ?['musicAutoplayRenderer']
              ?['contentPreviewRenderer']
              ?['content']
              ?['playlistPanelRenderer']
              ?['contents'] ??
          [];
    }

    // Path 3: Some responses nest it under watchNextRenderer directly
    if (contents.isEmpty) {
      final tabs = data['contents']
              ?['twoColumnWatchNextResults']
              ?['secondaryResults']
              ?['secondaryResults']
              ?['results'] ??
          [];
      if (tabs is List) contents = tabs;
    }

    // Path 4: Flat playlistPanelRenderer at top level (proxy-normalized format)
    if (contents.isEmpty) {
      contents = data['playlistPanelRenderer']?['contents'] ?? [];
    }

    // Path 5: Queue renderer (authenticated users)
    if (contents.isEmpty) {
      final tabs =
          data['contents']?['singleColumnMusicWatchNextResultsRenderer']
              ?['tabbedRenderer']
              ?['watchNextTabbedResultsRenderer']
              ?['tabs'] as List? ??
          [];
      for (final tab in tabs) {
        final panel = tab['tabRenderer']?['content']
            ?['musicQueueRenderer']
            ?['content']
            ?['playlistPanelRenderer']
            ?['contents'] as List?;
        if (panel != null && panel.isNotEmpty) {
          contents = panel;
          break;
        }
      }
    }

    final results = <Song>[];
    for (final item in contents) {
      final renderer = item['playlistPanelVideoRenderer'];
      if (renderer == null) continue;

      final videoId = renderer['videoId']?.toString();
      if (videoId == null || videoId.isEmpty) continue;

      // Parse artist from longBylineText runs (includes browse link)
      String artist = '';
      String? artistBrowseId;
      final bylineRuns =
          renderer['longBylineText']?['runs'] as List? ?? [];
      for (final run in bylineRuns) {
        final text = run['text']?.toString() ?? '';
        if (text == ' • ' || text.isEmpty) continue;
        if (artist.isEmpty) {
          artist = text;
          artistBrowseId = run['navigationEndpoint']
              ?['browseEndpoint']
              ?['browseId']
              ?.toString();
        }
      }
      if (artist.isEmpty) {
        artist = _getText(renderer['longBylineText']) ?? '';
      }

      results.add(Song(
        id: videoId,
        videoId: videoId,
        title: _getText(renderer['title']) ?? '',
        artist: artist,
        artistBrowseId: artistBrowseId,
        thumbnail: _extractThumb(renderer),
        duration: 0,
      ));
    }

    // Skip first item — it's the currently-playing song in watchNext responses
    return results.length > 1 ? results.sublist(1) : results;
  }
}

