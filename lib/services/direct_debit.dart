import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectDebitBankService {
  static Future<Map<String, dynamic>> initiate({
    required String secretKey,
    required String email,
    required String callbackUrl,
    required String accountNumber,
    required String bankCode,
    required String state,
    required String city,
    required String street,
  }) async {
    final url = Uri.parse("https://api.paystack.co/charge");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "channel": "direct_debit",
        "email": email,
        "callback_url": callbackUrl,
        "account": {
          "number": accountNumber,
          "bank_code": bankCode,
        },
        "address": {
          "state": state,
          "city": city,
          "street": street,
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to initiate direct debit: ${response.body}");
    }
  }
}
