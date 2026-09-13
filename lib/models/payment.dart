/// Payment-domain helpers.
library;

import '../api/export.dart';

const Set<String> _onlineWalletJsonValues = {'online', 'credit_card', 'gcash', 'maya'};

/// Returns true for payment methods that are settled online via a checkout
/// link (PayMongo), as opposed to [PaymentMethod.cash] and
/// [PaymentMethod.bankTransfer] which require admin approval.
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
