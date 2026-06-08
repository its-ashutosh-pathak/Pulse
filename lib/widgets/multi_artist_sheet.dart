import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../data/api/music_api.dart';
import '../data/models/song.dart';
import 'glass_container.dart';

class MultiArtistSheet extends StatefulWidget {
  final List<String> artistNames;

  const MultiArtistSheet({super.key, required this.artistNames});

  @override
  State<MultiArtistSheet> createState() => _MultiArtistSheetState();
}

class _MultiArtistSheetState extends State<MultiArtistSheet> {
  final _musicApi = MusicApi();
  List<Song?> _resolvedArtists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _resolveArtists();
  }

  Future<void> _resolveArtists() async {
    try {
      final futures = widget.artistNames.map((name) async {
        final res = await _musicApi.searchAll(name);
        final artistsList = res['artists'] as List<Song>?;
        if (artistsList != null && artistsList.isNotEmpty) {
          return artistsList.first;
        }
        return null;
      });

      final results = await Future.wait(futures);
      if (mounted) {
        setState(() {
          _resolvedArtists = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return GlassContainer(
      borderRadius: 24,
      blur: 24,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ──
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(LucideIcons.users, size: 20, color: accent),
                  const SizedBox(width: 10),
                  const Text('Select Artist',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            const Divider(height: 24, indent: 20, endIndent: 20),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.artistNames.length,
                  itemBuilder: (context, i) {
                    final artistName = widget.artistNames[i];
                    final artist = i < _resolvedArtists.length ? _resolvedArtists[i] : null;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          final router = GoRouter.of(context);
                          final t = DateTime.now().millisecondsSinceEpoch;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (artist?.browseId != null) {
                              router.push('/artist/${artist!.browseId}?t=$t');
                            } else {
                              router.push('/search?q=${Uri.encodeComponent(artistName)}&t=$t');
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 48, height: 48,
                                  child: artist?.thumbnail != null && artist!.thumbnail.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: ThumbnailUtils.getHighRes(artist.thumbnail, size: 120),
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) => Container(
                                            color: AppColors.surface,
                                            child: const Icon(LucideIcons.user, color: AppColors.textSecondary),
                                          ),
                                        )
                                      : Container(
                                          color: AppColors.surface,
                                          child: const Icon(LucideIcons.user, color: AppColors.textSecondary),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  artist?.title ?? artistName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
