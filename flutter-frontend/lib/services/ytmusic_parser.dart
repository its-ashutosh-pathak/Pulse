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
      final thumbs = node['thumbnails'] ?? node['thumbnail']?['thumbnails'] ?? [];
      if (thumbs.isEmpty) return '';
      // Get highest res square or just highest res
      thumbs.sort((a, b) => (b['width'] ?? 0).compareTo(a['width'] ?? 0));
      return thumbs.first['url']?.toString().replaceAll('http://', 'https://') ?? '';
    } catch (_) {
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
      
      final videoId = renderer['playlistItemData']?['videoId'] ?? 
                      titleNode?['navigationEndpoint']?['watchEndpoint']?['videoId'];
      
      final browseId = titleNode?['navigationEndpoint']?['browseEndpoint']?['browseId'];
      
      String artist = 'Unknown';
      String album = '';
      
      if (flexColumns.length > 1) {
        final subRuns = flexColumns[1]?['musicResponsiveListItemFlexColumnRenderer']?['text']?['runs'] ?? [];
        if (subRuns.isNotEmpty) {
          artist = _getText(subRuns[0]) ?? 'Unknown';
          if (subRuns.length > 2) {
            album = _getText(subRuns[2]) ?? '';
          }
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
        type: type,
      );
    } catch (_) {
      return null;
    }
  }

  static List<HomeSection> parseHomeFeed(Map<String, dynamic> data) {
    final sections = <HomeSection>[];
    try {
      final tabs = data['contents']?['singleColumnBrowseResultsRenderer']?['tabs'] ?? [];
      final tabContent = tabs.isNotEmpty ? tabs[0]['tabRenderer']?['content']?['sectionListRenderer']?['contents'] : [];
      
      for (var section in tabContent) {
        final header = section['musicCarouselShelfRenderer']?['header']?['musicCarouselShelfBasicHeaderRenderer']?['title'];
        final title = _getText(header) ?? 'Recommended';
        
        final items = section['musicCarouselShelfRenderer']?['contents'] ?? [];
        final parsedItems = items.map((i) {
          final renderer = i['musicTwoRowItemRenderer'];
          if (renderer == null) return null;
          
          final videoId = renderer['navigationEndpoint']?['watchEndpoint']?['videoId'];
          final browseId = renderer['navigationEndpoint']?['browseEndpoint']?['browseId'];
          
          return Song(
            id: videoId ?? browseId ?? '',
            videoId: videoId ?? '',
            title: _getText(renderer['title']) ?? '',
            artist: _getText(renderer['subtitle']) ?? '',
            thumbnail: _extractThumb(renderer),
            browseId: browseId,
            type: videoId != null ? 'SONG' : 'PLAYLIST',
          );
        }).whereType<Song>().toList();

        if (parsedItems.isNotEmpty) {
          sections.add(HomeSection(title: title, items: parsedItems));
        }
      }
    } catch (_) {}
    return sections;
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
    } catch (_) {}
    return results;
  }

  static Playlist parsePlaylist(Map<String, dynamic> data, String id) {
    final tracks = <Song>[];
    String title = 'Playlist';
    String description = '';
    String thumbnail = '';

    try {
      final header = data['header']?['musicResponsiveHeaderRenderer'] ?? data['header']?['musicDetailHeaderRenderer'];
      title = _getText(header?['title']) ?? title;
      description = _getText(header?['description']) ?? description;
      thumbnail = _extractThumb(header);

      final contents = data['contents']?['singleColumnBrowseResultsRenderer']?['tabs']?[0]?['tabRenderer']?['content']?['sectionListRenderer']?['contents'] ?? [];
      for (var section in contents) {
        final items = section['musicPlaylistShelfRenderer']?['contents'] ?? [];
        for (var item in items) {
          final song = _parseResponsiveListItem(item);
          if (song != null && song.videoId.isNotEmpty) tracks.add(song);
        }
      }
    } catch (_) {}

    return Playlist(
      id: id,
      name: title,
      description: description,
      thumbnail: thumbnail,
      type: 'YTM_PLAYLIST',
      songs: tracks,
      songCount: tracks.length,
      createdBy: 'YouTube Music',
    );
  }

  static Artist parseArtist(Map<String, dynamic> data, String browseId) {
    String name = 'Artist';
    String description = '';
    String thumbnail = '';
    final topSongs = <Song>[];
    final albums = <Song>[];

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
                albums.add(Song(
                  id: bId,
                  videoId: '',
                  title: _getText(renderer['title']) ?? '',
                  artist: name,
                  thumbnail: _extractThumb(renderer),
                  browseId: bId,
                  type: 'ALBUM',
                ));
              }
            }
          }
        }
      }
    } catch (_) {}

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

  static List<Song> parseWatchNext(Map<String, dynamic> data) {
    final results = <Song>[];
    try {
      final contents = data['contents']?['singleColumnMusicWatchNextResultsRenderer']?['tabbedRenderer']?['watchNextTabbedResultsRenderer']?['tabs']?[0]?['tabRenderer']?['content']?['musicQueueRenderer']?['content']?['playlistPanelRenderer']?['contents'] ?? [];
      for (var item in contents) {
        final renderer = item['playlistPanelVideoRenderer'];
        if (renderer == null) continue;
        
        final videoId = renderer['videoId'];
        if (videoId == null) continue;

        results.add(Song(
          id: videoId,
          videoId: videoId,
          title: _getText(renderer['title']) ?? '',
          artist: _getText(renderer['longBylineText']) ?? '',
          thumbnail: _extractThumb(renderer),
          duration: 0,
        ));
      }
    } catch (_) {}
    // Skip the first item as it's the currently playing song in watchNext
    return results.length > 1 ? results.sublist(1) : results;
  }
}
