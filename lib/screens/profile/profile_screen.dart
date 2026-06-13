import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/stats_provider.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../widgets/glass_container.dart';
import '../../core/constants/app_constants.dart';

/// Profile screen — port of Profile.jsx.
/// Avatar, stats dashboard (timeframe picker), top songs, top artists, footer.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameC = TextEditingController();

  // Stats
  String _activeTimeframe = 'week';
  final _musicApi = MusicApi();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Try immediately in case auth is already resolved
      _loadStats();
      // Also listen for auth to resolve (Firebase Auth is async on startup)
      // so stats are loaded even if the user wasn't ready on the first frame.
      ref.listenManual(authProvider, (prev, next) {
        if ((prev?.user == null || prev?.isLoggedIn == false) && next.isLoggedIn) {
          _loadStats();
        }
      });
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    super.dispose();
  }

  Future<void> _loadStats({bool force = false}) async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn) return;
    ref.read(statsProvider.notifier).loadStats(_activeTimeframe, force: force);
  }

  Future<void> _goToArtist(Map<String, dynamic> a) async {
    final name = a['artist'] ?? a['name'] ?? '';
    if (name.isEmpty) return;
    try {
      final browseId = a['browseId'] ?? a['id'];
      if (browseId != null && browseId.toString().isNotEmpty) {
        context.push('/artist/$browseId');
        return;
      }
      final bid = await _musicApi.resolveArtist(name);
      if (mounted) {
        if (bid != null) {
          context.push('/artist/$bid');
        } else {
          context.push('/search?q=${Uri.encodeComponent(name)}');
        }
      }
    } catch (_) {
      if (mounted) context.push('/search?q=${Uri.encodeComponent(name)}');
    }
  }

  String _formatTime(int ms) {
    if (ms <= 0) return '0m';
    final minutes = ms ~/ 60000;
    final hours = minutes ~/ 60;
    if (hours > 0) return '${hours}h ${minutes % 60}m';
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final stats = ref.watch(statsProvider);
    final accent = Theme.of(context).colorScheme.primary;
    final secondary = AppColors.computeSecondary(accent);

    if (!auth.isLoggedIn) {
      return Scaffold(
        body: SafeArea(bottom: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Not logged in',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final displayName = auth.displayName ?? 'Pulse User';
    final email = auth.user?.email ?? '';
    final initials = auth.initials;

    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 200),
          children: [
            // ── Avatar + Name + Email (centered, like PWA header) ──
            Center(
              child: Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [accent, secondary]),
                  boxShadow: [
                    BoxShadow(
                        color: accent.withValues(alpha: 0.3),
                        blurRadius: 20),
                  ],
                ),
                child: auth.photoURL != null && auth.photoURL!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          auth.photoURL!, fit: BoxFit.cover,
                          width: 96, height: 96,
                          errorBuilder: (_, __, ___) => _initialsWidget(initials),
                        ),
                      )
                    : _initialsWidget(initials),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(displayName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(email,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ),

            const SizedBox(height: 24),

            // ── Stats Dashboard ──
            // Timeframe picker
            GlassContainer(
              borderRadius: 12,
              padding: const EdgeInsets.all(4),
              child: Row(
                children: ['day', 'week', 'month', 'year'].map((tf) {
                  final isActive = _activeTimeframe == tf;
                  final label = tf[0].toUpperCase() + tf.substring(1);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _activeTimeframe = tf;
                        _loadStats(force: true);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isActive ? accent.withValues(alpha: 0.2) : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(label,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                  color: isActive ? accent : AppColors.textSecondary)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Main stats row
            Row(
              children: [
                // Listening Time
                Expanded(
                  flex: 3,
                  child: GlassContainer(
                    borderRadius: 14,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.clock, size: 14, color: accent),
                            const SizedBox(width: 6),
                            Text('LISTENING TIME',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                    color: accent, letterSpacing: 1)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_formatTime(stats.totalMs),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          _activeTimeframe == 'day' ? 'Today'
                              : _activeTimeframe == 'week' ? 'This week'
                              : _activeTimeframe == 'month' ? 'This month'
                              : 'This year',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Daily Average
                Expanded(
                  flex: 2,
                  child: GlassContainer(
                    borderRadius: 14,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.trendingUp, size: 14, color: accent),
                            const SizedBox(width: 6),
                            Text('DAILY AVG',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                    color: accent, letterSpacing: 1)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(stats.dailyAvgMinutes > 0 ? '${stats.dailyAvgMinutes}m' : '—',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        const Text('Per day',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Lifetime listening
            GlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.headphones, size: 14, color: accent),
                      const SizedBox(width: 6),
                      Text('LIFETIME LISTENING',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: accent, letterSpacing: 1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_formatTime(stats.lifetimeMs),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Total time listened to music on Pulse',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Top Songs ──
            Row(
              children: [
                Icon(LucideIcons.playCircle, size: 18, color: accent.withValues(alpha: 0.9)),
                const SizedBox(width: 8),
                const Text('Your Top Songs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            stats.topSongs.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Listening history will appear here.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: stats.topSongs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final s = stats.topSongs[i];
                        final thumb = ThumbnailUtils.getHighRes(
                            s['thumbnail'] ?? s['cover'] ?? '', size: 200);
                        return GestureDetector(
                          onTap: () {
                            try {
                              final songObj = Song.fromJson(s);
                              ref.read(audioProvider.notifier).playSong(songObj, clearQueue: true);
                            } catch (e) {
                              debugPrint('Failed to play top song: $e');
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: GlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('#${i + 1}',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: accent)),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: thumb.isNotEmpty
                                              ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                                                  errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                                              : Container(color: AppColors.surface),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(s['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(s['artist'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                  const SizedBox(height: 2),
                                  Text('${s['playCount'] ?? 0} plays',
                                      style: TextStyle(fontSize: 10, color: accent.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 24),

            // ── Top Artists ──
            Row(
              children: [
                Icon(LucideIcons.mic2, size: 18, color: accent.withValues(alpha: 0.9)),
                const SizedBox(width: 8),
                const Text('Your Top Artists',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            stats.topArtists.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Your favorite artists will appear here.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: stats.topArtists.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final a = stats.topArtists[i];
                        final name = a['artist'] ?? a['name'] ?? 'Unknown';
                        final thumb = ThumbnailUtils.getHighRes(
                            a['thumbnail'] ?? a['cover'] ?? '', size: 200);
                        final artistInitials = name.isNotEmpty ? name[0].toUpperCase() : '?';
                        return GestureDetector(
                          onTap: () => _goToArtist(a),
                          behavior: HitTestBehavior.opaque,
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: GlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('#${i + 1}',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: accent)),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: thumb.isNotEmpty
                                              ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                                                  errorWidget: (_, __, ___) =>
                                                      _artistPlaceholder(artistInitials, accent))
                                              : _artistPlaceholder(artistInitials, accent),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(_formatTime((a['totalSeconds'] ?? 0) * 1000),
                                      style: TextStyle(fontSize: 10, color: accent.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 24),

            // ── Action Buttons ──
            GlassContainer(
              borderRadius: 14,
              child: Column(
                children: [
                  _actionTile(LucideIcons.user, 'Edit Profile', () {
                    _showEditProfileDialog(context, displayName);
                  }),
                  _actionTile(LucideIcons.logOut, 'Sign Out', () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  }, danger: true),
                ],
              ),
            ),



            const SizedBox(height: 32),

            // ── Brand Footer ──
            Center(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 48, height: 48),
                  const SizedBox(height: 8),
                  const Text('Pulse',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Version $kAppVersion',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => launchUrl(
                      Uri.parse('https://itsashutoshpathak.vercel.app/'),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Made with ❤️ by ',
                              style: TextStyle(fontSize: 12,
                                  color: AppColors.textSecondary.withValues(alpha: 0.7))),
                          Text('Ashutosh Pathak',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                  color: accent)),
                        ],
                      ),
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

  Widget _initialsWidget(String initials) {
    return Center(
      child: Text(initials,
          style: const TextStyle(
              fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }

  Widget _artistPlaceholder(String initial, Color accent) {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Text(initial,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: accent)),
      ),
    );
  }

  Widget _actionTile(IconData icon, String label, VoidCallback onTap,
      {bool danger = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 17,
                  color: danger ? AppColors.danger : AppColors.textPrimary),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: TextStyle(
                    fontSize: 15,
                    color: danger ? AppColors.danger : AppColors.textPrimary)),
              ),
              Icon(LucideIcons.chevronRight, size: 16,
                  color: danger
                      ? AppColors.danger : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, String currentName) {
    _nameC.text = currentName;
    showDialog(
      context: context,
      builder: (ctx) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DISPLAY NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameC,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true, fillColor: AppColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: isSaving ? null : () async {
                    final name = _nameC.text.trim();
                    if (name.isNotEmpty) {
                      setStateDialog(() => isSaving = true);
                      await ref.read(authProvider.notifier).updateUserProfile(displayName: name);
                      if (ctx.mounted) {
                        setStateDialog(() => isSaving = false);
                        ctx.pop();
                      }
                    }
                  },
                  child: isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
