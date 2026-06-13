import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_container.dart';
import '../../core/constants/app_constants.dart';

/// Settings screen — pixel-perfect port of Settings.jsx.
/// Streaming/download quality, crossfade slider, data saver, accent color picker.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pickerOpen = false;

  // HSV state for color picker
  double _hue = 280;
  double _sat = 50;
  double _val = 64;

  @override
  void initState() {
    super.initState();
    // Initialize HSV from current accent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final color = ref.read(settingsProvider).accentColor;
      final hsv = HSVColor.fromColor(color);
      setState(() {
        _hue = hsv.hue;
        _sat = hsv.saturation * 100;
        _val = hsv.value * 100;
      });
    });
  }

  void _updateColor(double h, double s, double v) {
    setState(() { _hue = h; _sat = s; _val = v; });
    final color = HSVColor.fromAHSV(1.0, h, s / 100, v / 100).toColor();
    ref.read(settingsProvider.notifier).setAccentColor(color);
  }

  void _resetColor() {
    const defaultColor = Color(0xFF865AA4);
    ref.read(settingsProvider.notifier).setAccentColor(defaultColor);
    final hsv = HSVColor.fromColor(defaultColor);
    setState(() {
      _hue = hsv.hue;
      _sat = hsv.saturation * 100;
      _val = hsv.value * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final accent = settings.accentColor;

    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 200),
          children: [
            // ── Header ──
            Text('Settings',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),

            // ── Streaming Quality ──
            _sectionTitle(LucideIcons.volume2, 'Streaming Quality'),
            const SizedBox(height: 8),
            GlassContainer(
              borderRadius: 14,
              child: Column(
                children: ['automatic', 'low', 'normal', 'high'].map((q) =>
                  _qualityItem(q, settings.streamingQuality, accent, () =>
                    ref.read(settingsProvider.notifier).setStreamingQuality(q)),
                ).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Download Quality ──
            _sectionTitle(LucideIcons.download, 'Download Quality'),
            const SizedBox(height: 8),
            GlassContainer(
              borderRadius: 14,
              child: Column(
                children: ['automatic', 'low', 'normal', 'high'].map((q) =>
                  _qualityItem(q, settings.downloadQuality, accent, () =>
                    ref.read(settingsProvider.notifier).setDownloadQuality(q)),
                ).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Playback ──
            _sectionTitle(LucideIcons.music, 'Playback'),
            const SizedBox(height: 8),
            GlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Crossfade', style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Overlap tracks for gapless transitions',
                              style: TextStyle(fontSize: 11,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                      Text('${settings.crossfadeDuration}s',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700,
                              color: accent)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: settings.crossfadeDuration.toDouble(),
                      min: 0, max: 12,
                      divisions: 12,
                      onChanged: (v) =>
                          ref.read(settingsProvider.notifier)
                              .setCrossfade(v.toInt()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Data Usage ──
            _sectionTitle(LucideIcons.smartphone, 'Data Usage'),
            const SizedBox(height: 8),
            GlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data Saver', style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Stream at lower quality over cellular',
                          style: TextStyle(fontSize: 11,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                  Switch(
                    value: settings.dataSaverMode,
                    onChanged: (v) =>
                        ref.read(settingsProvider.notifier).setDataSaver(v),
                    activeThumbColor: accent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Appearance ──
            _sectionTitle(LucideIcons.palette, 'Appearance'),
            const SizedBox(height: 8),
            GlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Accent row
                  GestureDetector(
                    onTap: () => setState(() => _pickerOpen = !_pickerOpen),
                    child: Row(
                      children: [
                        Icon(LucideIcons.palette, size: 18, color: accent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Custom Accent',
                                  style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                '#${accent.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                                style: const TextStyle(fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent,
                            border: Border.all(
                                color: _pickerOpen
                                    ? Colors.white : Colors.white24,
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.3),
                                blurRadius: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Color picker
                  if (_pickerOpen) ...[
                    const SizedBox(height: 16),
                    // Hue slider
                    SizedBox(
                      height: 24,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 10,
                          trackShape: _HueTrackShape(),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8),
                          thumbColor: HSVColor.fromAHSV(1, _hue, 1, 1).toColor(),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12),
                        ),
                        child: Slider(
                          value: _hue,
                          min: 0, max: 360,
                          onChanged: (v) => _updateColor(v, _sat, _val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Saturation
                    _miniSlider('Saturation', _sat, (v) => _updateColor(_hue, v, _val)),
                    const SizedBox(height: 8),
                    // Brightness
                    _miniSlider('Brightness', _val, (v) => _updateColor(_hue, _sat, v)),
                    const SizedBox(height: 12),
                    // Reset
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _resetColor,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.surface,
                          ),
                          child: const Text('Reset Default',
                              style: TextStyle(fontSize: 11,
                                  color: AppColors.textSecondary)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Footer ──
            Center(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 48, height: 48),
                  const SizedBox(height: 8),
                  const Text('Pulse', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
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
                          const Text('Made with ❤️ by ',
                              style: TextStyle(fontSize: 11,
                                  color: AppColors.textSecondary)),
                          Text('Ashutosh Pathak',
                              style: TextStyle(fontSize: 11, color: accent)),
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

  Widget _sectionTitle(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600,
            color: AppColors.textSecondary, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _qualityItem(
      String quality, String active, Color accent, VoidCallback onTap) {
    final isActive = quality == active;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(quality[0].toUpperCase() + quality.substring(1),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)),
            Container(
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isActive ? accent : AppColors.textSecondary,
                    width: 2),
              ),
              child: isActive
                  ? Center(child: Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: accent)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniSlider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: const TextStyle(
              fontSize: 11, color: AppColors.textSecondary)),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            ),
            child: Slider(
              value: value,
              min: 0, max: 100,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom track shape for the hue slider — draws a rainbow gradient.
class _HueTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(PaintingContext context, Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 10;
    final trackRect = Rect.fromLTWH(
      offset.dx + 8,
      thumbCenter.dy - trackHeight / 2,
      parentBox.size.width - 16,
      trackHeight,
    );

    final rrect = RRect.fromRectAndRadius(trackRect, const Radius.circular(5));
    final paint = Paint()
      ..shader = LinearGradient(
        colors: List.generate(7, (i) =>
          HSVColor.fromAHSV(1, i * 60.0, 1, 1).toColor()),
      ).createShader(trackRect);

    context.canvas.drawRRect(rrect, paint);
  }
}
