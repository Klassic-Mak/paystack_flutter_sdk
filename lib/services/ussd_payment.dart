import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';

//For Nigerians
enum USSDProvider {
  gtBank, // 737
  uba, // 919
  sterling, // 822
  zenith, // 966
}

class USSDPaymentService {
  static Future<ChargeResponse> initialize({
    required String secretKey,
    required String email,
    required int amount,
    required String currency,
    required USSDProvider provider,
    Map<String, dynamic>? metadata,
  }) async {
    // Select USSD code based on bank/provider
    String ussdType = _getUSSDCode(provider);

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
        'ussd': {'type': ussdType},
        'metadata': metadata ?? {},
      }),
    );

    return ChargeResponse.fromJson(jsonDecode(response.body));
  }

  static String _getUSSDCode(USSDProvider provider) {
    switch (provider) {
      case USSDProvider.gtBank:
        return '737';
      case USSDProvider.uba:
        return '919';
      case USSDProvider.sterling:
        return '822';
      case USSDProvider.zenith:
        return '966';
      default:
        throw Exception('Unsupported USSD provider');
    }
  }
}
