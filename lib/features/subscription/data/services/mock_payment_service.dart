import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentMethodType { creditCard, bKash, nagad, applePay, googlePay }

class PaymentReceipt {
  final String transactionId;
  final String planId;
  final int amountCents;
  final String currency;
  final PaymentMethodType method;
  final DateTime timestamp;
  final String status;

  const PaymentReceipt({
    required this.transactionId,
    required this.planId,
    required this.amountCents,
    required this.currency,
    required this.method,
    required this.timestamp,
    required this.status,
  });
}

class MockPaymentService {
  Future<PaymentReceipt> processSubscriptionCheckout({
    required String userId,
    required String planId,
    required int amountCents,
    required String currency,
    required PaymentMethodType method,
    String? cardLast4,
  }) async {
    // Realistic payment network latency simulation
    await Future.delayed(const Duration(seconds: 2));

    return PaymentReceipt(
      transactionId: 'TXN-\${const Uuid().v4().substring(0, 8).toUpperCase()}',
      planId: planId,
      amountCents: amountCents,
      currency: currency,
      method: method,
      timestamp: DateTime.now(),
      status: 'succeeded',
    );
  }
}

final mockPaymentServiceProvider = Provider<MockPaymentService>((ref) {
  return MockPaymentService();
});
