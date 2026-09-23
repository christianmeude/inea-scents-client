import 'package:flutter/material.dart';

import '../config/theme.dart';
import 'inline_errors.dart';

/// C52: app-wide error display is toast-only on every width. The wide
/// (>=768px) nav-level [MaterialBanner] is gone — validation errors
/// render inline at the field/card level ([InlineFieldError],
/// [FormErrorSummary]) and only transient failures surface here, with
/// Retry. Friendly copy passes through untouched; raw errors stay
/// in logs, never on screen.
///
/// [transient] gates the Retry affordance. When omitted, the
/// [isTransientErrorMessage] heuristic over [message] decides — so a
/// caller that passes `onRetry` for a validation message gets no
/// Retry button. Pass `transient: true` explicitly to force it.
void showAppError(
  BuildContext context, {
  required String message,
  VoidCallback? onRetry,
  String retryLabel = 'Retry',
  String? actionLabel,
  VoidCallback? onAction,
  bool? transient,
}) {
  final isTransient = transient ?? isTransientErrorMessage(message);
  final messenger = ScaffoldMessenger.of(context);
  final hasRetry = onRetry != null && isTransient;
  final hasAction = onAction != null && actionLabel != null;
  messenger
    ..clearMaterialBanners()
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        // C31: plum/cream token both modes.
        backgroundColor: AppTheme.primaryButtonBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Retry keeps the toast up longer so it stays tappable.
        duration: Duration(seconds: (hasRetry || hasAction) ? 8 : 4),
        // C52: plain wrapping text — no Row/IconButton squeeze, so a
        // long message never overflows at 360px even with an action.
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.onPrimaryButton),
          softWrap: true,
        ),
        // C52: one action slot — extra action wins, else retry, and
        // retry only for transient failures. Validation copy never
        // gets a Retry button here (it renders in-card instead).
        action: hasAction || hasRetry
            ? SnackBarAction(
                key: Key(hasAction ? 'app_error_action' : 'app_error_retry'),
                label: actionLabel ?? retryLabel,
                // C31: cream action label on the plum token.
                textColor: AppTheme.onPrimaryButton,
                onPressed: () {
                  messenger.clearSnackBars();
                  (hasAction ? onAction : onRetry)?.call();
                },
              )
            : null,
      ),
    );
}

/// C52: clears any visible app error toast (plus legacy banners).
void hideAppError(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..clearSnackBars()
    ..clearMaterialBanners();
}
