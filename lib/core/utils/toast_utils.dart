import 'package:flutter/material.dart';
import '../../main.dart';

class ToastUtils {
  /// Shows a custom toast overlay that sits above all modal bottom sheets and dialogs.
  /// If [context] is provided, it tries to use its root navigator overlay.
  /// If [context] is null, it falls back to the global [navigatorKey].
  static void show(BuildContext? context, String message, {Duration duration = const Duration(seconds: 3), Widget? action}) {
    OverlayState? overlay;
    
    if (context != null) {
      overlay = Navigator.of(context, rootNavigator: true).overlay;
    } 
    
    if (overlay == null && navigatorKey.currentState != null) {
      overlay = navigatorKey.currentState!.overlay;
    }

    if (overlay != null) {
      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (context) {
          // Fallback padding if MediaQuery isn't available
          final bottomPadding = MediaQuery.maybeOf(context)?.padding.bottom ?? 0;
          return Positioned(
            bottom: bottomPadding + 20,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    if (action != null) ...[
                      const SizedBox(width: 8),
                      action,
                    ],
                  ],
                ),
              ),
            ),
          );
        }
      );
      overlay.insert(entry);
      Future.delayed(duration, () {
        if (entry.mounted) entry.remove();
      });
    }
  }
}
