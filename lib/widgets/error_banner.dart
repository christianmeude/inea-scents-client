import 'package:flutter/material.dart';

import 'card_surfaces.dart';
import 'responsive_app_shell.dart';

/// C30: app-wide error display. Wide (>=768px) surfaces errors as a
/// persistent inline [MaterialBanner] (never auto-dismisses); narrow
/// keeps the [SnackBar]. Both carry retry (when [onRetry] is given) +
/// dismiss. Friendly copy passes through untouched; raw errors stay
/// in logs, never on screen.
void showAppError(
  BuildContext context, {
  required String message,
  VoidCallback? onRetry,
  String retryLabel = 'Retry',
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  if (ResponsiveAppShell.isWideScreen(context)) {
    messenger
      ..clearSnackBars()
      ..clearMaterialBanners()
      ..showMaterialBanner(
        MaterialBanner(
          backgroundColor: CardSurfaces.cardBg(context),
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          leading: Icon(
            Icons.error_outline_rounded,
            color: CardSurfaces.onBrand(context),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: CardSurfaces.body(context),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          actions: [
            if (onRetry != null)
              TextButton(
                key: const Key('app_error_retry'),
                onPressed: () {
                  messenger.clearMaterialBanners();
                  onRetry();
                },
                style: TextButton.styleFrom(
                  foregroundColor: CardSurfaces.title(context),
                ),
                child: Text(retryLabel),
              ),
            if (onAction != null && actionLabel != null)
              TextButton(
                key: const Key('app_error_action'),
                onPressed: () {
                  messenger.clearMaterialBanners();
                  onAction();
                },
                style: TextButton.styleFrom(
                  foregroundColor: CardSurfaces.title(context),
                ),
                child: Text(actionLabel),
              ),
            TextButton(
              key: const Key('app_error_dismiss'),
              onPressed: messenger.clearMaterialBanners,
              style: TextButton.styleFrom(
                foregroundColor: CardSurfaces.title(context),
              ),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  } else {
    final hasRetry = onRetry != null;
    final hasAction = onAction != null && actionLabel != null;
    messenger
      ..clearMaterialBanners()
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          // C30: explicit dismiss (SnackBar keeps auto-dismiss too).
          content: Row(
            children: [
              Expanded(child: Text(message)),
              IconButton(
                key: const Key('app_error_dismiss'),
                icon: const Icon(Icons.close_rounded, size: 20),
                tooltip: 'Dismiss',
                visualDensity: VisualDensity.compact,
                onPressed: messenger.clearSnackBars,
              ),
            ],
          ),
          // C30: one action slot — extra action wins, else retry.
          action: hasAction || hasRetry
              ? SnackBarAction(
                  key: Key(hasAction ? 'app_error_action' : 'app_error_retry'),
                  label: actionLabel ?? retryLabel,
                  onPressed: () {
                    messenger.clearSnackBars();
                    (hasAction ? onAction : onRetry)?.call();
                  },
                )
              : null,
        ),
      );
  }
}

/// C30: clears any visible app error surface (banner or SnackBar).
void hideAppError(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..clearSnackBars()
    ..clearMaterialBanners();
}
