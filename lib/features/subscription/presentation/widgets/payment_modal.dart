import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/services/mock_payment_service.dart';

class PaymentCheckoutModal extends ConsumerStatefulWidget {
  final String planName;
  final String planId;
  final int amountCents;
  final String currency;

  const PaymentCheckoutModal({
    super.key,
    required this.planName,
    required this.planId,
    required this.amountCents,
    required this.currency,
  });

  @override
  ConsumerState<PaymentCheckoutModal> createState() => _PaymentCheckoutModalState();
}

class _PaymentCheckoutModalState extends ConsumerState<PaymentCheckoutModal> {
  PaymentMethodType _selectedMethod = PaymentMethodType.creditCard;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Checkout: ${widget.planName}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondaryDark),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Total: ${widget.currency} ${(widget.amountCents / 100).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Select Payment Method',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: AppSpacing.sm),
          _buildMethodTile(PaymentMethodType.creditCard, 'Credit / Debit Card (Visa, MC)', Icons.credit_card),
          _buildMethodTile(PaymentMethodType.bKash, 'bKash Mobile Banking', Icons.account_balance_wallet_outlined),
          _buildMethodTile(PaymentMethodType.nagad, 'Nagad Mobile Wallet', Icons.payments_outlined),
          _buildMethodTile(PaymentMethodType.applePay, 'Apple Pay / Google Pay', Icons.phone_iphone),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            text: _isProcessing ? 'Authorizing Secure Payment...' : 'Confirm & Subscribe',
            isLoading: _isProcessing,
            onPressed: _isProcessing ? null : _handlePayment,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildMethodTile(PaymentMethodType type, String label, IconData icon) {
    final isSelected = _selectedMethod == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = type),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(40) : AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderDark),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryLight : AppColors.textSecondaryDark),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    color: isSelected ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  )),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    setState(() => _isProcessing = true);
    final paymentService = ref.read(mockPaymentServiceProvider);

    try {
      final receipt = await paymentService.processSubscriptionCheckout(
        userId: 'user-1',
        planId: widget.planId,
        amountCents: widget.amountCents,
        currency: widget.currency,
        method: _selectedMethod,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Payment Successful! Receipt: ${receipt.transactionId}. Pro features unlocked!'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
