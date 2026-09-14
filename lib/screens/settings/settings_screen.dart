import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_container.dart';
import '../../core/constants/app_constants.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';

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
            Text(AppLocalizations.of(context)!.settingsTitle,
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),

            // ── Streaming Quality ──
            _sectionTitle(LucideIcons.volume2, AppLocalizations.of(context)!.settingsStreamingQuality),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              child: Column(
                children: ['automatic', 'low', 'normal', 'high'].map((q) =>
                  _qualityItem(context, q, settings.streamingQuality, accent, () =>
                    ref.read(settingsProvider.notifier).setStreamingQuality(q)),
                ).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Download Quality ──
            _sectionTitle(LucideIcons.download, AppLocalizations.of(context)!.settingsDownloadQuality),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              child: Column(
                children: ['automatic', 'low', 'normal', 'high'].map((q) =>
                  _qualityItem(context, q, settings.downloadQuality, accent, () =>
                    ref.read(settingsProvider.notifier).setDownloadQuality(q)),
                ).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── Playback ──
            _sectionTitle(LucideIcons.music, AppLocalizations.of(context)!.settingsPlayback),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.settingsCrossfade, style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(AppLocalizations.of(context)!.settingsCrossfadeDesc,
                                style: TextStyle(fontSize: 11,
                                    color: AppColors.textSecondary),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
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
                              .setCrossfade(v.toInt(), syncToFirestore: false),
                      onChangeEnd: (v) =>
                          ref.read(settingsProvider.notifier)
                              .setCrossfade(v.toInt(), syncToFirestore: true),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Data Usage ──
            _sectionTitle(LucideIcons.smartphone, AppLocalizations.of(context)!.settingsDataUsage),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.settingsDataSaver, style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(AppLocalizations.of(context)!.settingsDataSaverDesc,
                            style: TextStyle(fontSize: 11,
                                color: AppColors.textSecondary),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
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
            _sectionTitle(LucideIcons.palette, AppLocalizations.of(context)!.settingsAppearance),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
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
                              Text(AppLocalizations.of(context)!.settingsCustomAccent,
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
                    _miniSlider(AppLocalizations.of(context)!.settingsSaturation, _sat, (v) => _updateColor(_hue, v, _val)),
                    const SizedBox(height: 8),
                    // Brightness
                    _miniSlider(AppLocalizations.of(context)!.settingsBrightness, _val, (v) => _updateColor(_hue, _sat, v)),
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
                          child: Text(AppLocalizations.of(context)!.settingsResetDefault,
                              style: const TextStyle(fontSize: 11,
                                  color: AppColors.textSecondary)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Language ──
            _sectionTitle(LucideIcons.globe, AppLocalizations.of(context)!.settingsLanguage),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showLanguageSelector(context, settings, accent),
                child: Row(
                  children: [
                    Icon(LucideIcons.globe, size: 18, color: accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.settingsLanguage,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _getLanguageName(settings.appLocale),
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textSecondary),
                  ],
                ),
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
                  Text(AppLocalizations.of(context)!.profileVersion(kAppVersion),
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
                          Flexible(
                            child: Text(AppLocalizations.of(context)!.profileMadeWithHeartBy,
                                style: const TextStyle(fontSize: 11,
                                    color: AppColors.textSecondary),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          Flexible(
                            child: Text(AppLocalizations.of(context)!.profileAuthorName,
                                style: TextStyle(fontSize: 11, color: accent),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
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
        Flexible(
          child: Text(label, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: AppColors.textSecondary, letterSpacing: 0.5),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _qualityItem(
      BuildContext context, String quality, String active, Color accent, VoidCallback onTap) {
    final isActive = quality == active;
    
    String label = quality;
    switch(quality) {
      case 'automatic': label = AppLocalizations.of(context)!.settingsQualityAutomatic; break;
      case 'low': label = AppLocalizations.of(context)!.settingsQualityLow; break;
      case 'normal': label = AppLocalizations.of(context)!.settingsQualityNormal; break;
      case 'high': label = AppLocalizations.of(context)!.settingsQualityHigh; break;
    }
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
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

  String _getLanguageName(String? localeCode) {
    if (localeCode == 'hi') return 'हिन्दी';
    if (localeCode == 'af') return 'Afrikaans';
    if (localeCode == 'mai') return 'मैथिली';
    if (localeCode == 'sa') return 'संस्कृतम्';
    if (localeCode == 'mr') return 'मराठी';
    if (localeCode == 'pa') return 'ਪੰਜਾਬੀ';
    if (localeCode == 'ne') return 'नेपाली';
    if (localeCode == 'bn') return 'বাংলা';
    if (localeCode == 'te') return 'తెలుగు';
    if (localeCode == 'ta') return 'தமிழ்';
    if (localeCode == 'kn') return 'ಕನ್ನಡ';
    if (localeCode == 'or') return 'ଓଡ଼ିଆ';
    if (localeCode == 'ml') return 'മലയാളം';
    if (localeCode == 'gu') return 'ગુજરાતી';
    if (localeCode == 'ur') return 'اردو';
    if (localeCode == 'as') return 'অসমীয়া';
    if (localeCode == 'fr') return 'Français';
    if (localeCode == 'ru') return 'Русский';
    if (localeCode == 'ja') return '日本語';
    if (localeCode == 'ko') return '한국어';
    if (localeCode == 'pt') return 'Português';
    if (localeCode == 'ar') return 'العربية';
    if (localeCode == 'es') return 'Español';
    if (localeCode == 'zh') return '简体中文';
    if (localeCode == 'de') return 'Deutsch';
    if (localeCode == 'id') return 'Bahasa Indonesia';
    if (localeCode == 'tr') return 'Türkçe';
    if (localeCode == 'vi') return 'Tiếng Việt';
    if (localeCode == 'it') return 'Italiano';
    return 'English';
  }

  void _showLanguageSelector(BuildContext context, SettingsState settings, Color accent) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return GlassContainer(
          borderRadius: 24,
          blur: 24,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.415,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.settingsLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _languageItem(ctx, 'en', 'English', settings.appLocale, accent),
                          _languageItem(ctx, 'hi', 'हिन्दी', settings.appLocale, accent),
                          _languageItem(ctx, 'af', 'Afrikaans', settings.appLocale, accent),
                          _languageItem(ctx, 'mai', 'मैथिली', settings.appLocale, accent),
                          _languageItem(ctx, 'sa', 'संस्कृतम्', settings.appLocale, accent),
                          _languageItem(ctx, 'mr', 'मराठी', settings.appLocale, accent),
                          _languageItem(ctx, 'pa', 'ਪੰਜਾਬੀ', settings.appLocale, accent),
                          _languageItem(ctx, 'ne', 'नेपाली', settings.appLocale, accent),
                          _languageItem(ctx, 'bn', 'বাংলা', settings.appLocale, accent),
                          _languageItem(ctx, 'te', 'తెలుగు', settings.appLocale, accent),
                          _languageItem(ctx, 'ta', 'தமிழ்', settings.appLocale, accent),
                          _languageItem(ctx, 'kn', 'ಕನ್ನಡ', settings.appLocale, accent),
                          _languageItem(ctx, 'or', 'ଓଡ଼ିଆ', settings.appLocale, accent),
                          _languageItem(ctx, 'ml', 'മലയാളം', settings.appLocale, accent),
                          _languageItem(ctx, 'gu', 'ગુજરાતી', settings.appLocale, accent),
                          _languageItem(ctx, 'ur', 'اردو', settings.appLocale, accent),
                          _languageItem(ctx, 'as', 'অসমীয়া', settings.appLocale, accent),
                          _languageItem(ctx, 'fr', 'Français', settings.appLocale, accent),
                          _languageItem(ctx, 'ru', 'Русский', settings.appLocale, accent),
                          _languageItem(ctx, 'ja', '日本語', settings.appLocale, accent),
                          _languageItem(ctx, 'ko', '한국어', settings.appLocale, accent),
                          _languageItem(ctx, 'pt', 'Português', settings.appLocale, accent),
                          _languageItem(ctx, 'ar', 'العربية', settings.appLocale, accent),
                          _languageItem(ctx, 'es', 'Español', settings.appLocale, accent),
                          _languageItem(ctx, 'zh', '简体中文', settings.appLocale, accent),
                          _languageItem(ctx, 'de', 'Deutsch', settings.appLocale, accent),
                          _languageItem(ctx, 'id', 'Bahasa Indonesia', settings.appLocale, accent),
                          _languageItem(ctx, 'tr', 'Türkçe', settings.appLocale, accent),
                          _languageItem(ctx, 'vi', 'Tiếng Việt', settings.appLocale, accent),
                          _languageItem(ctx, 'it', 'Italiano', settings.appLocale, accent),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _languageItem(BuildContext context, String localeCode, String label, String? active, Color accent) {
    final effectiveActive = active ?? 'en';
    final isActive = localeCode == effectiveActive;
    
    return InkWell(
      onTap: () {
        ref.read(settingsProvider.notifier).setAppLocale(localeCode);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 15,
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
              fontSize: 11, color: AppColors.textSecondary),
            maxLines: 1, overflow: TextOverflow.ellipsis),
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
