import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:paystack_flutter/model/paystack_request_response.dart';

class MobileMoneyService {
  static Future<PaystackRequestResponse> charge({
    required String secretKey,
    required String email,
    required int amount,
    required String currency,
    required String phone,
    required String provider,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.paystack.co/charge'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amount,
        'email': email,
        'currency': currency,
        'mobile_money': {
          'phone': phone,
          'provider': provider,
        },
        'metadata': metadata ?? {},
      }),
    );

    return PaystackRequestResponse.fromJson(jsonDecode(response.body));
  }
}
