import 'dart:async';
import 'package:flutter/material.dart';
import '../../main.dart';

class ToastUtils {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  /// Dismisses any currently visible toast overlay immediately.
  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_currentEntry != null && _currentEntry!.mounted) {
      _currentEntry!.remove();
    }
    _currentEntry = null;
  }

  /// Shows a custom toast overlay that sits above all modal bottom sheets and dialogs.
  /// Users can swipe left or right to dismiss it immediately without waiting.
  static void show(
    BuildContext? context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Widget? action,
  }) {
    // Dismiss any currently visible toast to prevent overlapping/stacked entries.
    dismiss();

    OverlayState? overlay;
    if (context != null && context.mounted) {
      overlay = Navigator.maybeOf(context, rootNavigator: true)?.overlay;
    }
    overlay ??= navigatorKey.currentState?.overlay;

    if (overlay == null) return;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) {
        final bottomPadding = MediaQuery.maybeOf(ctx)?.padding.bottom ?? 0;
        final isDesktop = Theme.of(ctx).platform == TargetPlatform.windows ||
                          Theme.of(ctx).platform == TargetPlatform.macOS ||
                          Theme.of(ctx).platform == TargetPlatform.linux;

        return _ToastWidget(
          key: UniqueKey(),
          message: message,
          action: action,
          isDesktop: isDesktop,
          bottomPadding: bottomPadding,
          onDismiss: () {
            if (_currentEntry == entry) {
              dismiss();
            }
          },
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(duration, () {
      if (_currentEntry == entry) {
        dismiss();
      }
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Widget? action;
  final bool isDesktop;
  final double bottomPadding;
  final VoidCallback onDismiss;

  const _ToastWidget({
    super.key,
    required this.message,
    this.action,
    required this.isDesktop,
    required this.bottomPadding,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toastContent = Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (widget.action != null) ...[
              const SizedBox(width: 8),
              widget.action!,
            ],
          ],
        ),
      ),
    );

    final dismissibleToast = Dismissible(
      key: const ValueKey('pulse_toast_dismissible'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => widget.onDismiss(),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: toastContent,
        ),
      ),
    );

    if (widget.isDesktop) {
      return Positioned(
        bottom: widget.bottomPadding + 120,
        left: 0,
        right: 0,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: dismissibleToast,
            ),
          ),
        ),
      );
    }

    return Positioned(
      bottom: widget.bottomPadding + 148,
      left: 16,
      right: 16,
      child: dismissibleToast,
    );
  }
}
