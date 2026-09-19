/// Payment-domain helpers.
library;

import '../api/export.dart';

const Set<String> _onlineWalletJsonValues = {'online'};

/// Returns true for payment methods that are settled online via a checkout
/// link (PayMongo), as opposed to [PaymentMethod.cash] which requires admin
/// approval. Retired values (credit_card, gcash, maya, bank_transfer) are
/// rejected by the API and never count as online.
bool isOnlinePayment(PaymentMethod method) {
  return _onlineWalletJsonValues.contains(method.json);
}

bool isOnlinePaymentString(String? method) {
  if (method == null) return false;
  return _onlineWalletJsonValues.contains(method);
}

bool isValidEmail(String email) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
}
