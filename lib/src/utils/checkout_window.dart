/// Gesture-held checkout tab for the web booking flow.
///
/// Desktop browsers only grant `window.open` inside the tap's user-activation
/// window. The booking POST resolves seconds after the tap, so opening the
/// checkout then is popup-blocked. Instead the UI opens a placeholder tab
/// synchronously in the tap handler and navigates it once the checkout URL
/// exists.
///
/// Platform split via conditional import: real tabs on the web
/// (`checkout_window_web.dart`), no-op everywhere else
/// (`checkout_window_stub.dart`, where mobile keeps `url_launcher`).
library;

import 'checkout_window_stub.dart'
    if (dart.library.js_interop) 'checkout_window_web.dart'
    as impl;

/// Opaque handle to a held checkout tab. The tab is owned until it is
/// navigated to the payment URL or closed — never both.
abstract interface class CheckoutWindow {
  /// Navigate the held tab to the payment [url].
  void navigateTo(String url);

  /// Close the held tab (e.g. booking failed before a URL existed).
  void close();
}

/// Opens a placeholder tab showing a branded waiting page. Returns null on
/// platforms without tabs (mobile) or when the open itself was blocked —
/// callers fall back to `launchUrl` plus the on-screen recovery button.
CheckoutWindow? openCheckoutWindow() => impl.openCheckoutWindow();
