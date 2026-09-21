import 'package:flutter/material.dart';

/// C40: mobile overscroll clamp helper.
///
/// Root cause: SDK-default overscroll (StretchingOverscrollIndicator on
/// Android / bounce on iOS) — no screen set explicit physics (see the
/// former C25 "platform-default physics" comments), so any content
/// displacement past the edge on overscroll drag is the SDK default,
/// not app-level decoration. Fix: per-screen [ClampingScrollPhysics]
/// gated to mobile width only (< 768px); desktop/web physics untouched.
class MobileClampScroll {
  static const double mobileMaxWidth = 768.0;

  /// Returns [ClampingScrollPhysics] on mobile widths, null elsewhere
  /// (null = platform default, desktop/web untouched).
  static ScrollPhysics? physicsForWidth(double width) {
    if (width < mobileMaxWidth) return const ClampingScrollPhysics();
    return null;
  }

  /// Width-gated physics from the ambient [MediaQuery].
  static ScrollPhysics? physicsOf(BuildContext context) {
    return physicsForWidth(MediaQuery.sizeOf(context).width);
  }
}
