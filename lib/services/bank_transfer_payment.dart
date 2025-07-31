// lib/services/bank_transfer_payment.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';

class BankTransferService {
  static Future<ChargeResponse> initializeTransfer({
    required String secretKey,
    required String email,
    required int amount, // in kobo or pesewa
    String currency = 'NGN', // or 'GHS' if supported
    String? reference,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse("https://api.paystack.co/transaction/initialize");

    final body = {
      "email": email,
      "amount": amount,
      "currency": currency,
      "channels": ["bank_transfer"],
    };

    if (reference != null) body["reference"] = reference;
    if (metadata != null) body["metadata"] = metadata;

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return ChargeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Bank Transfer init failed: ${response.statusCode} ${response.body}",
      );
    }
  }
}
