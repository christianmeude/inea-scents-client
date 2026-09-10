import 'checkout_window.dart';

/// Non-web platforms have no tabs to hold: mobile keeps the `url_launcher`
/// path, so there is nothing to open here.
CheckoutWindow? openCheckoutWindow() => null;
