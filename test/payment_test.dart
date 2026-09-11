import 'package:flutter_test/flutter_test.dart';
import 'package:inea_scents_client/api/export.dart';
import 'package:inea_scents_client/models/payment.dart';

void main() {
  group('isOnlinePayment', () {
    test('returns true for online wallet/checkout methods', () {
      expect(isOnlinePayment(PaymentMethod.creditCard), isTrue);
    });

    test('returns false for offline methods', () {
      expect(isOnlinePayment(PaymentMethod.cash), isFalse);
      expect(isOnlinePayment(PaymentMethod.bankTransfer), isFalse);
    });
  });

  group('isOnlinePaymentString', () {
    test('returns true for online wallet/checkout methods', () {
      expect(isOnlinePaymentString('credit_card'), isTrue);
      expect(isOnlinePaymentString('gcash'), isTrue);
      expect(isOnlinePaymentString('maya'), isTrue);
    });

    test('returns false for offline and unknown methods', () {
      expect(isOnlinePaymentString('cash'), isFalse);
      expect(isOnlinePaymentString('bank_transfer'), isFalse);
      expect(isOnlinePaymentString('card'), isFalse);
      expect(isOnlinePaymentString(null), isFalse);
    });
  });

  group('isValidEmail', () {
    test('returns true for valid emails', () {
      expect(isValidEmail('test@example.com'), isTrue);
      expect(isValidEmail('maria.santos@gmail.com'), isTrue);
      expect(isValidEmail('user+tag@domain.ph'), isTrue);
    });

    test('returns false for invalid emails', () {
      expect(isValidEmail(''), isFalse);
      expect(isValidEmail('notanemail'), isFalse);
      expect(isValidEmail('missing@'), isFalse);
      expect(isValidEmail('@domain.com'), isFalse);
    });
  });
}
