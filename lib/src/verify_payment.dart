import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/payment_data.dart';

class PaystackVerify {
  static Future<PaymentData> checkStatus({
    required String secretKey,
    required String reference,
  }) async {
    final response = await http.get(
      Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PaymentData.fromJson(json['data']);
    } else {
      throw Exception('Transaction verification failed: ${response.body}');
    }
  }
}
