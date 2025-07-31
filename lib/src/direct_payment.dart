import 'package:paystack_flutter/model/payment_data.dart';
import 'package:paystack_flutter/model/paystack_request_response.dart';

class DirectPayment {
  /// The secret key for Paystack integration.
  final String secretKey;

  /// The URL to redirect to after payment.
  final String redirectUrl;

  /// The [PaymentData] object containing payment details.
  final PaymentData paymentData;

  /// Callback function to handle the response after payment.
  final Function(PaystackRequestResponse) onResponse;

  DirectPayment({
    required this.secretKey,
    required this.redirectUrl,
    required this.paymentData,
    required this.onResponse,
  });
}
