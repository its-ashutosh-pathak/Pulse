import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/import_provider.dart';
import '../../services/spotify_auth_service.dart';
import '../../services/spotify_embed_scraper.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/spotify_playlists_sheet.dart';

/// Import Playlist screen — port of ImportPlaylist.jsx.
/// Paste YT Music URLs to import playlists.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _clientIdC = TextEditingController();

  @override
  void dispose() {
    _clientIdC.dispose();
    super.dispose();
  }

  Future<void> _connectToSpotify() async {
    final clientId = _clientIdC.text.trim();
    if (clientId.isEmpty) return;
    
    try {
      await SpotifyAuthService.authenticate(clientId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully Connected to Spotify!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        
        // Show the bottom sheet!
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SpotifyPlaylistsSheet(clientId: clientId),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            // ── Header ──
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(LucideIcons.arrowLeft, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text('Connect Spotify',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),

            const SizedBox(height: 24),

            // ── Instructions ──
            GlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/spotify.logo.png', width: 20, height: 20),
                      const SizedBox(width: 8),
                      const Text('Setup Spotify Integration',
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To bypass Spotify\'s strict rate limits and import all your playlists instantly, you must use your own free developer key. Follow these simple steps:',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildStep(context, '1', 'Open the Spotify Developer Dashboard.', 
                    action: TextButton(
                      onPressed: () => launchUrl(Uri.parse('https://developer.spotify.com/dashboard'), mode: LaunchMode.externalApplication),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text('developer.spotify.com', style: TextStyle(color: accent, decoration: TextDecoration.underline)),
                    )
                  ),
                  _buildStep(context, '2', 'Log in and click "Create app".'),
                  _buildStep(context, '3', 'Fill in any App Name and Description.'),
                  _buildStep(context, '4', 'Under "Redirect URIs", paste the following exact URL:',
                    action: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Expanded(child: Text('pulse://spotify-callback', style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.white70))),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: 'pulse://spotify-callback'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Redirect URI Copied!', style: TextStyle(color: Colors.white)),
                                  backgroundColor: accent,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(LucideIcons.copy, size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  _buildStep(context, '5', 'Save the app, copy your "Client ID" from settings, and paste it below.'),
                  
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 32, bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.info, size: 16, color: accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Important: The Spotify account used to create this developer app must have an active Premium subscription.',
                            style: TextStyle(fontSize: 12, color: accent, height: 1.4, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Client ID Input ──
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Icon(LucideIcons.key, size: 16,
                        color: AppColors.textSecondary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _clientIdC,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Paste your Spotify Client ID here...',
                        hintStyle: TextStyle(fontSize: 12,
                            color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Connect Button ──
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _connectToSpotify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Connect & Load Library',
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String text, {Widget? action}) {
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
            child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                if (action != null) action,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

