import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/app_colors.dart';

import '../../services/spotify_auth_service.dart';

import '../../widgets/glass_container.dart';
import '../../widgets/spotify_playlists_sheet.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import 'package:pulse/core/utils/error_mapper.dart';

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
        ToastUtils.show(context, AppLocalizations.of(context)!.importSuccess);
        
        // Show the bottom sheet!
        showModalBottomSheet(useRootNavigator: true, 
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SpotifyPlaylistsSheet(clientId: clientId),
        );
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.show(context, AppLocalizations.of(context)!.importFailed(ErrorMapper.getLocalizedError(context, e)));
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
                Text(AppLocalizations.of(context)!.importTitle,
                    style: const TextStyle(
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
                      Text(AppLocalizations.of(context)!.importSetupTitle,
                          style: const TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.importSetupDesc,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildStep(context, '1', AppLocalizations.of(context)!.importStep1, 
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
                  _buildStep(context, '2', AppLocalizations.of(context)!.importStep2),
                  _buildStep(context, '3', AppLocalizations.of(context)!.importStep3),
                  _buildStep(context, '4', AppLocalizations.of(context)!.importStep4,
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
                              ToastUtils.show(context, AppLocalizations.of(context)!.importRedirectCopied, duration: const Duration(seconds: 2));
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
                  _buildStep(context, '5', AppLocalizations.of(context)!.importStep5),
                  
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
                            AppLocalizations.of(context)!.importImportant,
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
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.importClientIdHint,
                        hintStyle: const TextStyle(fontSize: 12,
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
                child: Text(AppLocalizations.of(context)!.importConnectButton,
                    style: const TextStyle(
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

