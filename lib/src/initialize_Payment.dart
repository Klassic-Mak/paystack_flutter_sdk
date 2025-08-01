import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';

class PaystackTransaction {
  static Future<ChargeResponse> initialize({
    required String secretKey,
    required String email,
    required double amount,
    required String currency,
    required String reference,
    String? callbackUrl,
    Map<String, dynamic>? metadata,
    List<String>? channels,
    String? plan,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.paystack.co/transaction/initialize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $secretKey',
      },
      body: jsonEncode({
        "email": email,
        "amount": (amount * 100).toInt(),
        "currency": currency,
        "reference": reference,
        "callback_url": callbackUrl,
        "metadata": metadata ?? {},
        "channels": channels,
        "plan": plan,
      }),
    );

    if (response.statusCode == 200) {
      return ChargeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Paystack init failed: ${response.body}");
    }
  }
}
