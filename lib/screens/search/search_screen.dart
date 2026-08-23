import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/song_tile.dart';
import '../../widgets/song_action_sheet.dart';
import '../../widgets/glass_container.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import 'package:pulse/core/utils/error_mapper.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../services/shazam_service.dart';

/// Search screen — port of Search.jsx.
/// Debounced search with autocomplete, top result card, songs/artists/albums/playlists.
/// Search history and result caching are managed by [SearchNotifier].
class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _speechToText = SpeechToText();
  bool _isListening = false;
  BuildContext? _listeningSheetContext;

  bool _isShazamListening = false;
  BuildContext? _shazamSheetContext;
  final _shazamService = ShazamService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initial = widget.initialQuery;
      if (initial != null && initial.isNotEmpty) {
        if (_controller.text != initial) {
          _controller.text = initial;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: initial.length),
          );
        }
        final currentQuery = ref.read(searchProvider).query;
        if (currentQuery != initial) {
          ref.read(searchProvider.notifier).onQueryChanged(initial);
        }
      } else {
        // Restore query text from provider (e.g. when navigating back normally)
        final currentQuery = ref.read(searchProvider).query;
        if (currentQuery.isNotEmpty && _controller.text != currentQuery) {
          _controller.text = currentQuery;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: currentQuery.length),
          );
        }
      }
    });

    // Only initialize speech_to_text on supported platforms.
    // The mic button is already hidden on Windows/Linux, but calling
    // initialize() on an unsupported platform can throw MissingPluginException.
    if (kIsWeb || (!Platform.isWindows && !Platform.isLinux)) {
      _speechToText.initialize(
        onError: (error) => debugPrint('[Speech] Error: $error'),
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _shazamService.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
      ref.read(audioProvider.notifier).playSong(item, clearQueue: true, isManual: true);
      // Add to search history (mirrors PWA setHistory behavior)
      ref.read(searchProvider.notifier).addToHistory(item);
    } else if (item.browseId != null) {
      context.push('/playlist/${item.browseId}');
    }
  }

  void _dismissListeningSheet() {
    _speechToText.stop();
    if (mounted) setState(() => _isListening = false);
    if (_listeningSheetContext != null) {
      Navigator.of(_listeningSheetContext!).pop();
      _listeningSheetContext = null;
    }
  }

  void _dismissShazamSheet() {
    _shazamService.cancel();
    if (mounted) setState(() => _isShazamListening = false);
    if (_shazamSheetContext != null) {
      Navigator.of(_shazamSheetContext!).pop();
      _shazamSheetContext = null;
    }
  }

  Future<void> _toggleShazamSearch() async {
    if (_isShazamListening) {
      _dismissShazamSheet();
      return;
    }

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ToastUtils.show(context, AppLocalizations.of(context)!.searchMicPermissionRequired);
      }
      return;
    }

    if (!mounted) return;

    setState(() => _isShazamListening = true);

    // Show the bottom sheet without awaiting it, so we can run our logic concurrently
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        _shazamSheetContext = ctx;
        return _ShazamSearchSheet(onCancel: _dismissShazamSheet);
      },
    ).then((_) {
      _shazamSheetContext = null;
      if (mounted && _isShazamListening) {
        setState(() => _isShazamListening = false);
      }
    });

    try {
      final result = await _shazamService.recognizeNearbySong();

      if (!mounted) return;
      _dismissShazamSheet();

      if (result != null && result.containsKey('track') && mounted) {
        final track = result['track'];
        final title = track['title'] ?? AppLocalizations.of(context)!.searchUnknownSong;
        final subtitle = track['subtitle'] ?? AppLocalizations.of(context)!.searchUnknownArtist;

        // Put the result into the search bar and trigger a search
        _controller.text = '$title $subtitle';
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        ref.read(searchProvider.notifier).onQueryChanged(_controller.text);
        ref.read(searchProvider.notifier).hideSuggestions();
      } else if (mounted) {
        final errorMsg = result != null && result.containsKey('error') 
            ? AppLocalizations.of(context)!.searchError(ErrorMapper.getLocalizedError(context, result['error'])) 
            : AppLocalizations.of(context)!.searchNoSongDetected;
        
        ToastUtils.show(context, errorMsg);
      }
    } catch (e) {
      _dismissShazamSheet();
      if (mounted) {
        ToastUtils.show(context, AppLocalizations.of(context)!.searchError(ErrorMapper.getLocalizedError(context, e)), duration: const Duration(seconds: 4));
      }
    }
  }

  Future<void> _toggleVoiceSearch() async {
    if (_isListening) {
      _dismissListeningSheet();
      return;
    }

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ToastUtils.show(context, AppLocalizations.of(context)!.searchMicPermissionRequired);
      }
      return;
    }

    final available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _dismissListeningSheet();
        }
      },
    );
    if (!available) {
      if (mounted) {
        ToastUtils.show(context, AppLocalizations.of(context)!.searchSpeechNotAvailable);
      }
      return;
    }

    setState(() => _isListening = true);
    _speechToText.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        ref
            .read(searchProvider.notifier)
            .onQueryChanged(result.recognizedWords);
        if (result.finalResult) {
          _dismissListeningSheet();
        }
      },
    );

    // Show bottom sheet
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (sheetCtx) {
        _listeningSheetContext = sheetCtx;
        return _VoiceSearchSheet(onCancel: _dismissListeningSheet);
      },
    );
    // Sheet dismissed by user swipe — stop listening too
    if (_isListening) _dismissListeningSheet();
    _listeningSheetContext = null;
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(searchProvider);
    final audio = ref.watch(audioProvider);
    final accent = Theme.of(context).colorScheme.primary;
    final isDesktop = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                if (!isDesktop)
                  // ── Search bar ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.glassBackground,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 14),
                                      child: Icon(
                                        LucideIcons.search,
                                        size: 18,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _controller,
                                        focusNode: _focusNode,
                                        autofocus: false,
                                        style: const TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)!.searchHint,
                                          hintStyle: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                        ),
                                        onChanged: (q) {
                                          ref
                                              .read(searchProvider.notifier)
                                              .onQueryChanged(q);
                                        },
                                        onSubmitted: (_) {
                                          ref
                                              .read(searchProvider.notifier)
                                              .hideSuggestions();
                                        },
                                      ),
                                    ),
                                    if (search.query.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          _controller.clear();
                                          ref
                                              .read(searchProvider.notifier)
                                              .clearQuery();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Icon(
                                            LucideIcons.x,
                                            size: 18,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    if (kIsWeb || (!Platform.isWindows && !Platform.isLinux))
                                      GestureDetector(
                                        onTap: _toggleVoiceSearch,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 14,
                                            left: 4,
                                          ),
                                          child: Icon(
                                            _isListening
                                                ? LucideIcons.mic
                                                : LucideIcons.mic,
                                            size: 18,
                                            color: _isListening
                                                ? accent
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _toggleShazamSearch,
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.glassBackground,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: 30,
                                    height: 30,
                                    color: _isShazamListening
                                        ? accent
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Suggestions dropdown
                        if (search.showSuggestions &&
                            search.suggestions.isNotEmpty &&
                            search.query.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: AppColors.glassBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...search.suggestions.map((s) {
                                  return InkWell(
                                    onTap: () {
                                      _controller.text = s;
                                      _controller.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(offset: s.length),
                                          );
                                      ref
                                          .read(searchProvider.notifier)
                                          .selectSuggestion(s);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            LucideIcons.search,
                                            size: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              s,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                if (!isDesktop)
                  const SizedBox(height: 8),

                // ── Content ──
                Expanded(
                  child: search.query.isEmpty
                      ? _buildRecentSearches(search, audio)
                      : search.isSearching
                      ? _buildSkeletons()
                      : search.hasResults
                      ? _buildResults(search, audio, accent)
                      : _buildNoResults(search.query),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Searches (mirrors PWA "Recent Searches" section) ──

  Widget _buildRecentSearches(SearchState search, AudioState audio) {
    if (search.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.search, size: 36, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.searchRecentEmpty,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.searchRecentSearches,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => ref.read(searchProvider.notifier).clearHistory(),
                child: Text(
                  AppLocalizations.of(context)!.searchClearAll,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // History list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: search.history.length,
            itemBuilder: (context, i) {
              final song = search.history[i];
              final isPlaying = audio.currentSong?.videoId == song.videoId;

              return SongTile(
                song: song,
                isPlaying: isPlaying,
                onTap: () => _handlePlay(song),
                onLongPress: () => _showMenu(song),
                trailing: GestureDetector(
                  onTap: () => _showMenu(song),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      LucideIcons.moreVertical,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.music,
            size: 36,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.searchNoResultsFor(query),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.searchTryDifferentKeywords,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletons() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: List.generate(
        6,
        (_) => const Padding(
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
        ),
      ),
    );
  }

  Widget _buildResults(SearchState search, AudioState audio, Color accent) {
    final songs = search.results['songs'] ?? [];
    final artists = search.results['artists'] ?? [];
    final albums = search.results['albums'] ?? [];
    final playlists = search.results['playlists'] ?? [];
    final topResult = songs.isNotEmpty
        ? songs.first
        : albums.isNotEmpty
        ? albums.first
        : null;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      children: [
        // Top result
        if (topResult != null) ...[
          _sectionLabel(AppLocalizations.of(context)!.searchTopResult),
          _buildTopResult(topResult, accent),
          const SizedBox(height: 8),
        ],

        // Songs
        if (songs.isNotEmpty) ...[
          _sectionLabel(AppLocalizations.of(context)!.searchSongsLabel),
          ...songs.map(
            (song) => SongTile(
              song: song,
              isPlaying: audio.currentSong?.videoId == song.videoId,
              onTap: () => _handlePlay(song),
              onLongPress: () => _showMenu(song),
              trailing: GestureDetector(
                onTap: () => _showMenu(song),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    LucideIcons.moreVertical,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Artists
        if (artists.isNotEmpty) ...[
          _sectionLabel(AppLocalizations.of(context)!.searchArtistsLabel),
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
          _sectionLabel(AppLocalizations.of(context)!.searchAlbumsLabel),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: albums.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) =>
                  _buildCollectionCard(albums[i], LucideIcons.disc),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Playlists
        if (playlists.isNotEmpty) ...[
          _sectionLabel(AppLocalizations.of(context)!.searchPlaylistsLabel),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: playlists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) =>
                  _buildCollectionCard(playlists[i], LucideIcons.radio),
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
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: thumb.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumb,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            Container(color: AppColors.surface),
                      )
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
                        Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${song.artist}${song.album.isNotEmpty ? ' · ${song.album}' : ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [accent, AppColors.computeSecondary(accent)],
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 28,
                      color: AppColors.background,
                    ),
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
    final name = artist.title.isNotEmpty ? artist.title : AppLocalizations.of(context)!.searchArtistLabel;
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
                  ? CachedNetworkImageProvider(thumb)
                  : null,
              child: thumb.isEmpty
                  ? Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              AppLocalizations.of(context)!.searchArtistLabel,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
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
                    width: 130,
                    height: 130,
                    child: thumb.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumb,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.surface),
                          )
                        : Container(color: AppColors.surface),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
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
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              '${item.artist}${item.year != null ? ' · ${item.year}' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(Song song) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SongActionSheet(song: song),
    );
  }
}

class _VoiceSearchSheet extends StatefulWidget {
  final VoidCallback onCancel;

  const _VoiceSearchSheet({required this.onCancel});

  @override
  State<_VoiceSearchSheet> createState() => _VoiceSearchSheetState();
}

class _VoiceSearchSheetState extends State<_VoiceSearchSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.4,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return GlassContainer(
      borderRadius: 24,
      blur: 24,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Mic icon with pulsing animation
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing ripple
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Static inner mic icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.mic, size: 40, color: accent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.searchListening,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.searchSpeakNow,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  onPressed: widget.onCancel,
                  child: Text(AppLocalizations.of(context)!.searchCancel, style: const TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShazamSearchSheet extends StatefulWidget {
  final VoidCallback onCancel;

  const _ShazamSearchSheet({required this.onCancel});

  @override
  State<_ShazamSearchSheet> createState() => _ShazamSearchSheetState();
}

class _ShazamSearchSheetState extends State<_ShazamSearchSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.4,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return GlassContainer(
      borderRadius: 24,
      blur: 24,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Disc icon with pulsing animation
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing ripple
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Static inner disc icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 40,
                        height: 40,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.searchIdentifying,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.searchListeningForSong,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  onPressed: widget.onCancel,
                  child: Text(AppLocalizations.of(context)!.searchCancel, style: const TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
