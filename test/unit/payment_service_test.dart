import 'package:flutter_test/flutter_test.dart';
import 'package:routineflow_app/features/subscription/data/services/mock_payment_service.dart';

void main() {
  group('Mock Payment Service Tests', () {
    final paymentService = MockPaymentService();

    test('processSubscriptionCheckout generates valid receipt', () async {
      final receipt = await paymentService.processSubscriptionCheckout(
        userId: 'test-user-1',
        planId: 'pro_monthly',
        amountCents: 499,
        currency: 'USD',
        method: PaymentMethodType.creditCard,
      );

      expect(receipt.status, equals('succeeded'));
      expect(receipt.planId, equals('pro_monthly'));
      expect(receipt.amountCents, equals(499));
      expect(receipt.transactionId.startsWith('TXN-'), isTrue);
    });

    test('processSubscriptionCheckout works with mobile wallets', () async {
      final receipt = await paymentService.processSubscriptionCheckout(
        userId: 'test-user-2',
        planId: 'pro_yearly',
        amountCents: 3999,
        currency: 'USD',
        method: PaymentMethodType.bKash,
      );

      expect(receipt.status, equals('succeeded'));
      expect(receipt.method, equals(PaymentMethodType.bKash));
    });
  });
}
