import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            // ── Avatar + Name + Email (left-aligned header) ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 111, height: 111,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: [accent, secondary]),
                  ),
                  child: _buildAvatarWidget(auth.photoURL, initials, accent, 111),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 111,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 160,
                            child: GlassContainer(
                              borderRadius: 14,
                              child: _actionTile(LucideIcons.pencil, 'Edit Profile', () {
                                _showEditProfileBottomSheet(context, displayName, auth.photoURL, initials);
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBellIcon(auth.user?.uid, auth.isAdmin, accent),
              ],
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
                                  const Text('Artist', maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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
      {bool danger = false, Widget? trailing}) {
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
              if (trailing != null) ...[
                trailing,
                const SizedBox(width: 8),
              ],
              Icon(LucideIcons.chevronRight, size: 16,
                  color: danger
                      ? AppColors.danger : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBellIcon(String? userId, bool isAdmin, Color accent) {
    return Transform.translate(
      offset: const Offset(12, -12),
      child: IconButton(
        icon: Stack(
          children: [
            Icon(LucideIcons.bell, size: 24, color: accent),
            if (userId != null)
              if (isAdmin)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('support_channels').where('unreadByAdmin', isEqualTo: true).snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.docs.length ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0, top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                        child: Text('$count', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    );
                  },
                )
              else
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('support_messages')
                      .where(Filter.or(
                        Filter('userId', isEqualTo: userId),
                        Filter('isAnnouncement', isEqualTo: true)
                      ))
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
                    int count = 0;
                    for (var doc in docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final time = (data['timestamp'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                      final isMe = data['senderId'] == userId;
                      if (!isMe && time > ref.watch(unreadBadgeTimeProvider)) {
                        count++;
                      }
                    }
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0, top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                        child: Text(count > 9 ? '9+' : '$count', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    );
                  },
                )
          ],
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final now = DateTime.now().millisecondsSinceEpoch + 60000; // +1 min buffer
          await prefs.setInt('lastOpenedSupportTime', now);
          if (mounted) {
            ref.read(unreadBadgeTimeProvider.notifier).state = now;
            context.push('/communication');
          }
        },
      ),
    );
  }

  Widget _buildAvatarWidget(String? photoURL, String initials, Color accent, double size) {
    if (photoURL != null && photoURL.isNotEmpty) {
      if (photoURL.startsWith('assets/')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            photoURL,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (_, __, ___) => _initialsWidget(initials),
          ),
        );
      } else if (photoURL.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: photoURL,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorWidget: (_, __, ___) => _initialsWidget(initials),
          ),
        );
      }
    }
    return _initialsWidget(initials);
  }

  void _showEditProfileBottomSheet(BuildContext context, String currentName, String? currentPhotoURL, String initials) {
    _nameC.text = currentName;
    String? selectedAvatar = currentPhotoURL;
    if (selectedAvatar != null && selectedAvatar.isEmpty) selectedAvatar = null;
    final accent = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return GlassContainer(
              borderRadius: 24, blur: 24,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 20, right: 20, top: 24,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Center(
                    child: Container(
                      width: 36, height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const Text('EDIT PROFILE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 111, height: 111,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showAvatarPicker(context, selectedAvatar, (newAvatar) {
                              setStateSheet(() => selectedAvatar = newAvatar);
                            });
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildAvatarWidget(selectedAvatar, initials, accent, 111),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Icon(LucideIcons.pencil, color: accent.withValues(alpha: 0.7), size: 32),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('DISPLAY NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _nameC,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                filled: true, fillColor: AppColors.surface,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: isSaving ? null : () async {
                                    final name = _nameC.text.trim();
                                    if (name.isNotEmpty) {
                                      setStateSheet(() => isSaving = true);
                                      await ref.read(authProvider.notifier).updateUserProfile(
                                            displayName: name,
                                            photoURL: selectedAvatar ?? '',
                                          );
                                      if (ctx.mounted) {
                                        setStateSheet(() => isSaving = false);
                                        ctx.pop();
                                      }
                                    }
                                  },
                                  child: isSaving
                                      ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: accent))
                                      : const Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
             ),
            );
          },
        );
      },
    );
  }

  void _showAvatarPicker(BuildContext context, String? currentAvatar, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return GlassContainer(
          borderRadius: 24,
          blur: 24,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Choose Avatar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      final path = 'assets/avatars/${index + 1}.jpeg';
                      final isSelected = currentAvatar == path;
                      return GestureDetector(
                        onTap: () {
                          onSelect(path);
                          ctx.pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3) : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.asset(path, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
