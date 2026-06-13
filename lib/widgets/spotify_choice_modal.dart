import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import 'glass_container.dart';

/// Shown when user taps "Import from Spotify" in the library.
/// Lets the user choose between embed-scrape (≤100 songs) or BYOA (>100 songs).
class SpotifyChoiceModal extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSelectEmbed;
  final VoidCallback onSelectByoa;

  const SpotifyChoiceModal({
    super.key,
    required this.onClose,
    required this.onSelectEmbed,
    required this.onSelectByoa,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // prevent close on card tap
            child: GlassContainer(
              borderRadius: 24, blur: 24,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(0),
              child: _buildChoice(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Spotify logo + title
          Row(
            children: [
              Image.asset('assets/spotify.logo.png', width: 36, height: 36),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Import from Spotify', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Text('Choose your playlist size', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),

          // ≤100 option
          _ChoiceCard(
            icon: LucideIcons.list,
            iconColor: Colors.blueAccent,
            title: '100 songs or fewer',
            subtitle: 'Paste a public Spotify playlist URL.',
            badge: null,
            onTap: onSelectEmbed,
          ),

          const SizedBox(height: 12),

          // >100 option
          _ChoiceCard(
            icon: LucideIcons.infinity,
            iconColor: const Color(0xFF1DB954),
            title: 'More than 100 songs',
            subtitle: 'Connect your own Spotify Developer App to import unlimited tracks.',
            badge: null,
            onTap: onSelectByoa,
          ),

          const SizedBox(height: 16),
          TextButton(
            onPressed: onClose,
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textSecondary),
              ],
            ),
            if (badge != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Text(badge!, style: const TextStyle(fontSize: 11, color: Colors.amber, height: 1.4)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
