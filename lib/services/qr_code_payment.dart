import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';

class QRPaymentService {
  static Future<ChargeResponse> initialize({
    required String secretKey,
    required String email,
    required int amount, // in kobo
    required String currency,
    Map<String, dynamic>? metadata,
    String? provider, // optional: "visa", "mastercard", "verve", "paycode"
  }) async {
    final response = await http.post(
      Uri.parse('https://api.paystack.co/charge'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'amount': amount,
        'currency': currency,
        'qr': {
          if (provider != null) 'provider': provider, // optional
        },
        'metadata': metadata ?? {},
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChargeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("QR Payment failed: ${response.body}");
    }
  }
}
