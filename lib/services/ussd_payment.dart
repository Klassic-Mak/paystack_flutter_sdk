import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';

class USSDPaymentService {
  static Future<ChargeResponse> initialize({
    required String secretKey,
    required String email,
    required int amount,
    String? bank,
    required String currency,
    Map<String, dynamic>? metadata,
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
        'ussd': {'type': '737'}, // e.g., GTBank (737), optional
        'metadata': metadata ?? {},
      }),
    );

    return ChargeResponse.fromJson(jsonDecode(response.body));
  }
}
