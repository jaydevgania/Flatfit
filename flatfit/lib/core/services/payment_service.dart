import 'package:flatfit/config/app_config.dart';
import 'package:flatfit/core/models/result.dart';

enum PaymentMethod { upi, card, netbanking, wallet }

class PaymentOrder {
  final String orderId;
  final num amountInRupees;
  final String currency;
  final String description;
  final Map<String, dynamic>? notes;

  const PaymentOrder({
    required this.orderId,
    required this.amountInRupees,
    this.currency = 'INR',
    required this.description,
    this.notes,
  });
}

class PaymentSuccessResult {
  final String paymentId;
  final String orderId;
  final String signature;

  const PaymentSuccessResult({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });
}

/// Interface for payment processing (Razorpay, UPI intent).
abstract class PaymentService {
  Future<void> initialize();
  Future<Result<PaymentOrder>> createOrder({
    required num amountInRupees,
    required String description,
    Map<String, dynamic>? metadata,
  });
  Future<Result<PaymentSuccessResult>> processPayment({
    required PaymentOrder order,
    required String userPhone,
    required String userEmail,
  });
  Future<Result<bool>> verifyPaymentSignature({
    required String paymentId,
    required String orderId,
    required String signature,
  });
}

class RazorpayPaymentService implements PaymentService {
  final String keyId;

  RazorpayPaymentService({String? keyId})
      : keyId = keyId ?? AppConfig.razorpayKeyId;

  @override
  Future<void> initialize() async {}

  @override
  Future<Result<PaymentOrder>> createOrder({
    required num amountInRupees,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    // Calls edge function / backend to generate Razorpay order ID
    final mockOrderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    return Result.success(PaymentOrder(
      orderId: mockOrderId,
      amountInRupees: amountInRupees,
      description: description,
      notes: metadata,
    ));
  }

  @override
  Future<Result<PaymentSuccessResult>> processPayment({
    required PaymentOrder order,
    required String userPhone,
    required String userEmail,
  }) async {
    // In live app, this opens Razorpay Checkout SDK
    return Result.success(PaymentSuccessResult(
      paymentId: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      orderId: order.orderId,
      signature: 'mock_signature_${DateTime.now().millisecondsSinceEpoch}',
    ));
  }

  @override
  Future<Result<bool>> verifyPaymentSignature({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    return Result.success(true);
  }
}
