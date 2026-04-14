import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/song_tile.dart';
import '../../widgets/song_action_sheet.dart';

/// Search screen — port of Search.jsx.
/// Debounced search with autocomplete, top result card, songs/artists/albums/playlists.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _musicApi = MusicApi();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _searchTimer;
  Timer? _suggestTimer;

  String _query = '';
  bool _isSearching = false;
  bool _showSuggestions = false;
  List<String> _suggestions = [];
  Map<String, List<Song>> _results = {
    'songs': [], 'albums': [], 'playlists': [], 'artists': [],
  };

  @override
  void dispose() {
    _searchTimer?.cancel();
    _suggestTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String q) {
    _query = q;
    _searchTimer?.cancel();
    _suggestTimer?.cancel();

    if (q.trim().isEmpty) {
      setState(() {
        _results = {'songs': [], 'albums': [], 'playlists': [], 'artists': []};
        _suggestions = [];
        _isSearching = false;
        _showSuggestions = false;
      });
      return;
    }

    setState(() { _isSearching = true; _showSuggestions = true; });

    // Suggestions (200ms)
    _suggestTimer = Timer(const Duration(milliseconds: 200), () async {
      try {
        final sugg = await _musicApi.getSuggestions(q);
        if (mounted && _query == q) {
          setState(() => _suggestions = sugg.take(8).toList());
        }
      } catch (_) {}
    });

    // Search (550ms debounce)
    _searchTimer = Timer(const Duration(milliseconds: 550), () async {
      try {
        setState(() => _showSuggestions = false);
        final data = await _musicApi.searchAll(q);
        if (mounted && _query == q) {
          setState(() {
            _results = {
              'songs': (data['songs'] as List<dynamic>?)
                      ?.map((e) => e is Song ? e : Song.fromJson(e as Map<String, dynamic>))
                      .toList() ?? [],
              'albums': (data['albums'] as List<dynamic>?)
                      ?.map((e) => e is Song ? e : Song.fromJson(e as Map<String, dynamic>))
                      .toList() ?? [],
              'playlists': (data['playlists'] as List<dynamic>?)
                      ?.map((e) => e is Song ? e : Song.fromJson(e as Map<String, dynamic>))
                      .toList() ?? [],
              'artists': (data['artists'] as List<dynamic>?)
                      ?.map((e) => e is Song ? e : Song.fromJson(e as Map<String, dynamic>))
                      .toList() ?? [],
            };
            _isSearching = false;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  bool get _hasResults =>
      (_results['songs']?.length ?? 0) +
          (_results['albums']?.length ?? 0) +
          (_results['playlists']?.length ?? 0) +
          (_results['artists']?.length ?? 0) >
      0;

  void _handlePlay(Song item) {
    final type = item.type;
    if (['PLAYLIST', 'ALBUM', 'YTM_PLAYLIST', 'YTM_ALBUM'].contains(type)) {
      final id = item.browseId ?? item.id;
      if (id.isNotEmpty) context.push('/playlist/$id');
      return;
    }
    if (type == 'ARTIST') {
      final id = item.browseId ?? item.id;
      if (id.isNotEmpty) context.push('/artist/$id');
      return;
    }
    if (item.isPlayable) {
      ref.read(audioProvider.notifier).playSong(item);
    } else if (item.browseId != null) {
      context.push('/playlist/${item.browseId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(audioProvider);
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  // Search input
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 14),
                          child: Icon(LucideIcons.search,
                              size: 18, color: AppColors.textSecondary),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: true,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'Songs, artists, albums, playlists…',
                              hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onChanged: _onQueryChanged,
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              _onQueryChanged('');
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 14),
                              child: Icon(LucideIcons.x,
                                  size: 18, color: AppColors.textSecondary),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Suggestions dropdown
                  if (_showSuggestions && _suggestions.isNotEmpty && _query.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _suggestions.map((s) {
                          return InkWell(
                            onTap: () {
                              _controller.text = s;
                              _onQueryChanged(s);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.search,
                                      size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(s,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Content ──
            Expanded(
              child: _query.isEmpty
                  ? _buildEmptyState()
                  : _isSearching
                      ? _buildSkeletons()
                      : _hasResults
                          ? _buildResults(audio, accent)
                          : _buildNoResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.search, size: 36, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          const Text('Search for your favorite music',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.music, size: 36, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text('No results for "$_query"',
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          const Text('Try different keywords',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSkeletons() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: List.generate(6, (_) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            SkeletonLoader(width: 48, height: 48, borderRadius: 8),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(width: 160, height: 14, borderRadius: 4),
                  SizedBox(height: 6),
                  SkeletonLoader(width: 100, height: 10, borderRadius: 4),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildResults(AudioState audio, Color accent) {
    final songs = _results['songs'] ?? [];
    final artists = _results['artists'] ?? [];
    final albums = _results['albums'] ?? [];
    final playlists = _results['playlists'] ?? [];
    final topResult = songs.isNotEmpty ? songs.first : albums.isNotEmpty ? albums.first : null;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      children: [
        // Top result
        if (topResult != null) ...[
          _sectionLabel('Top result'),
          _buildTopResult(topResult, accent),
          const SizedBox(height: 8),
        ],

        // Songs
        if (songs.isNotEmpty) ...[
          _sectionLabel('Songs'),
          ...songs.map((song) => SongTile(
            song: song,
            isPlaying: audio.currentSong?.videoId == song.videoId,
            onTap: () => _handlePlay(song),
            onLongPress: () => _showMenu(song),
            trailing: GestureDetector(
              onTap: () => _showMenu(song),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(LucideIcons.moreVertical,
                    size: 18, color: AppColors.textSecondary),
              ),
            ),
          )),
          const SizedBox(height: 16),
        ],

        // Artists
        if (artists.isNotEmpty) ...[
          _sectionLabel('Artists'),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: artists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) => _buildArtistChip(artists[i]),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Albums
        if (albums.isNotEmpty) ...[
          _sectionLabel('Albums'),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: albums.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) => _buildCollectionCard(albums[i], LucideIcons.disc),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Playlists
        if (playlists.isNotEmpty) ...[
          _sectionLabel('Playlists'),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: playlists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) => _buildCollectionCard(playlists[i], LucideIcons.radio),
            ),
          ),
        ],

        const SizedBox(height: 120),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary)),
    );
  }

  Widget _buildTopResult(Song song, Color accent) {
    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 400);
    return GestureDetector(
      onTap: () => _handlePlay(song),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.glassBackground,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 160, width: double.infinity,
                child: thumb.isNotEmpty
                    ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                    : Container(color: AppColors.surface),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(song.title, maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text('${song.artist}${song.album.isNotEmpty ? ' · ${song.album}' : ''}',
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: accent),
                    child: const Icon(LucideIcons.play,
                        size: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistChip(Song artist) {
    final thumb = ThumbnailUtils.getHighRes(artist.thumbnail, size: 200);
    final name = artist.title.isNotEmpty ? artist.title : 'Artist';
    return GestureDetector(
      onTap: () {
        final id = artist.browseId ?? artist.id;
        if (id.isNotEmpty) context.push('/artist/$id');
      },
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.surface,
              backgroundImage: thumb.isNotEmpty
                  ? CachedNetworkImageProvider(thumb) : null,
              child: thumb.isEmpty
                  ? Text(name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700))
                  : null,
            ),
            const SizedBox(height: 6),
            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const Text('Artist',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(Song item, IconData icon) {
    final thumb = ThumbnailUtils.getHighRes(item.thumbnail, size: 300);
    return GestureDetector(
      onTap: () {
        final id = item.browseId ?? item.id;
        if (id.isNotEmpty) context.push('/playlist/$id');
      },
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    width: 130, height: 130,
                    child: thumb.isNotEmpty
                        ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.surface))
                        : Container(color: AppColors.surface),
                  ),
                  Positioned(
                    right: 6, bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(icon, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(
              '${item.artist}${item.year != null ? ' · ${item.year}' : ''}',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SongActionSheet(song: song),
    );
  }
}
