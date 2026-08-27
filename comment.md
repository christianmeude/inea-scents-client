The checkout experience will use the **provider-hosted checkout (PayMongo Checkout API)** via an **in-app WebView**, ensuring a frictionless flow without the app directly handling sensitive card data.

**The UX Flow:**
1. **User taps "Book & Pay"**: App sends booking details to the backend.
2. **Backend Setup**: Backend creates a `Pending` Booking, creates a PayMongo Checkout Session (with custom `success_url` and `cancel_url`), and returns the `checkout_url`.
3. **App Opens WebView**: Flutter app launches an in-app WebView to load the `checkout_url`.
4. **App Intercepts Return**: After payment (and 3D Secure/OTP), PayMongo redirects to the `success_url` or `cancel_url`. The Flutter app intercepts this URL change, closes the WebView, and brings the user back to native UI.
5. **App Polls for Confirmation**: App shows a 'Confirming payment...' screen while polling the backend for the booking status.
6. **Backend Webhook**: PayMongo sends a webhook to the backend confirming payment. Backend updates Booking to `Confirmed`.
7. **App Completes**: App polling detects the `Confirmed` status and shows the final Success Screen.
