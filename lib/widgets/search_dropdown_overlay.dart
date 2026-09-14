import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../providers/search_provider.dart';

import '../providers/audio_provider.dart';
import '../data/models/song.dart';
import 'song_action_sheet.dart';

class SearchDropdownOverlay extends ConsumerWidget {
  final VoidCallback onClose;

  const SearchDropdownOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    // Expand to full results height when we have results
    final maxHeight = searchState.hasResults ? 600.0 : 500.0;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildContent(context, ref, searchState),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, SearchState state) {
    if (state.query.isEmpty) {
      return _buildRecentSearches(context, ref, state);
    }
    if (state.isSearching && !state.hasResults) {
      return _buildLoading();
    }
    if (state.hasResults) {
      // Show suggestions row at top if available, then full results
      return _buildFullResults(context, ref, state);
    }
    if (state.suggestions.isNotEmpty) {
      return _buildSuggestionsOnly(context, ref, state);
    }
    return const SizedBox(
      height: 80,
      child: Center(
        child: Text('No results', style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 100,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  // ─── Recent Searches ───────────────────────────────────────────────────────

  Widget _buildRecentSearches(BuildContext context, WidgetRef ref, SearchState state) {
    if (state.history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'No recent searches',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent searches',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(searchProvider.notifier).clearHistory();
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...state.history.take(7).map((item) {
          return _buildSongTile(context, ref, item, fromHistory: true);
        }),
      ],
    );
  }

  // ─── Suggestions only (while typing, before results arrive) ───────────────

  Widget _buildSuggestionsOnly(BuildContext context, WidgetRef ref, SearchState state) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ...state.suggestions.take(6).map((suggestion) {
          return _buildSuggestionTile(context, ref, suggestion, state.query);
        }),
      ],
    );
  }

  // ─── Full results (shown after Enter or when results arrive) ──────────────

  Widget _buildFullResults(BuildContext context, WidgetRef ref, SearchState state) {
    final songs = state.results['songs'] ?? [];
    final artists = state.results['artists'] ?? [];
    final albums = state.results['albums'] ?? [];
    final playlists = state.results['playlists'] ?? [];
    final topResult = songs.isNotEmpty ? songs.first : albums.isNotEmpty ? albums.first : null;
    final accent = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Suggestions row at top (if still visible)
        if (state.suggestions.isNotEmpty && state.showSuggestions) ...[
          ...state.suggestions.take(3).map((s) {
            return _buildSuggestionTile(context, ref, s, state.query);
          }),
          const Divider(color: Colors.white10, height: 8),
        ],

        // Top result card
        if (topResult != null) ...[
          _sectionLabel('Top result'),
          _buildTopResultCard(context, ref, topResult, accent),
          const SizedBox(height: 8),
        ],

        // Songs
        if (songs.isNotEmpty) ...[
          _sectionLabel('Songs'),
          ...songs.take(5).map((song) {
            return _buildSongTile(context, ref, song);
          }),
          const SizedBox(height: 8),
        ],

        // Artists
        if (artists.isNotEmpty) ...[
          _sectionLabel('Artists'),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: artists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) => _buildArtistChip(context, artists[i]),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Albums
        if (albums.isNotEmpty) ...[
          _sectionLabel('Albums'),
          SizedBox(
            height: 165,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: albums.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _buildCollectionCard(context, albums[i]),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Playlists
        if (playlists.isNotEmpty) ...[
          _sectionLabel('Playlists'),
          SizedBox(
            height: 165,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: playlists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _buildCollectionCard(context, playlists[i]),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  // ─── Reusable tiles ────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(BuildContext context, WidgetRef ref, String suggestion, String query) {
    final lower = suggestion.toLowerCase();
    final queryLower = query.toLowerCase();
    final index = lower.indexOf(queryLower);

    List<TextSpan> spans = [];
    if (index != -1) {
      if (index > 0) spans.add(TextSpan(text: suggestion.substring(0, index), style: const TextStyle(fontWeight: FontWeight.normal)));
      spans.add(TextSpan(text: suggestion.substring(index, index + query.length), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
      if (index + query.length < suggestion.length) spans.add(TextSpan(text: suggestion.substring(index + query.length), style: const TextStyle(fontWeight: FontWeight.normal)));
    } else {
      spans.add(TextSpan(text: suggestion));
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: const Icon(LucideIcons.search, color: AppColors.textSecondary, size: 18),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          children: spans,
        ),
      ),
      onTap: () {
        ref.read(searchProvider.notifier).selectSuggestion(suggestion);
      },
    );
  }

  Widget _buildSongTile(BuildContext context, WidgetRef ref, Song item, {bool fromHistory = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(item.type.toLowerCase() == 'artist' ? 24 : 4),
        child: Image.network(
          item.thumbnail.isNotEmpty ? item.thumbnail : '',
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 44,
            height: 44,
            color: Colors.white10,
            child: const Icon(LucideIcons.music, color: Colors.white54, size: 18),
          ),
        ),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      subtitle: Text(
        '${_capitalize(item.type.toLowerCase())} • ${item.artist}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
      ),
      trailing: item.type.toLowerCase() == 'song'
          ? IconButton(
              icon: const Icon(LucideIcons.moreVertical, size: 16, color: AppColors.textSecondary),
              onPressed: () {
                final currentContext = context;
                showModalBottomSheet(
                  useRootNavigator: true,
                  context: currentContext,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => SongActionSheet(song: item),
                );
              },
            )
          : null,
      onTap: () => _handleItemTap(context, ref, item),
      onLongPress: item.type.toLowerCase() == 'song'
          ? () {
              showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => SongActionSheet(song: item),
              );
            }
          : null,
    );
  }

  Widget _buildTopResultCard(BuildContext context, WidgetRef ref, Song song, Color accent) {
    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 400);
    return GestureDetector(
      onTap: () => _handleItemTap(context, ref, song),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: thumb.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumb,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(color: Colors.white10),
                      )
                    : Container(color: Colors.white10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${song.artist}${song.album.isNotEmpty ? ' · ${song.album}' : ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, size: 22, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistChip(BuildContext context, Song artist) {
    final thumb = ThumbnailUtils.getHighRes(artist.thumbnail, size: 200);
    final name = artist.title.isNotEmpty ? artist.title : 'Artist';
    return GestureDetector(
      onTap: () {
        final id = artist.browseId ?? artist.id;
        if (id.isNotEmpty) context.push('/artist/$id');
        onClose();
      },
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white10,
              backgroundImage: thumb.isNotEmpty ? CachedNetworkImageProvider(thumb) : null,
              child: thumb.isEmpty
                  ? Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const Text('Artist', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, Song item) {
    final thumb = ThumbnailUtils.getHighRes(item.thumbnail, size: 300);
    return GestureDetector(
      onTap: () {
        final id = item.browseId ?? item.id;
        if (id.isNotEmpty) context.push('/playlist/$id');
        onClose();
      },
      child: SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 110,
                height: 110,
                child: thumb.isNotEmpty
                    ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover)
                    : Container(color: Colors.white10, child: const Icon(LucideIcons.music, color: Colors.white30)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              item.artist.isNotEmpty ? item.artist : _capitalize(item.type.toLowerCase()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tap handler ───────────────────────────────────────────────────────────

  void _handleItemTap(BuildContext context, WidgetRef ref, Song item) {
    ref.read(searchProvider.notifier).addToHistory(item);
    final type = item.type.toLowerCase();
    if (type == 'artist') {
      final id = item.browseId ?? item.id;
      if (id.isNotEmpty) context.push('/artist/$id');
      onClose();
    } else if (type == 'playlist' || type == 'album' || type == 'ep') {
      final id = item.browseId ?? item.id;
      if (id.isNotEmpty) context.push('/playlist/$id');
      onClose();
    } else {
      // Play song — keep dropdown open
      ref.read(audioProvider.notifier).playSong(item);
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
