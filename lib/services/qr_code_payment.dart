import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';
import 'package:paystack_flutter/widgets/pop_ups.dart';

class QRPaymentService {
  static Future<ChargeResponse> initialize({
    required String secretKey,
    required String email,
    required int amount, // in kobo
    required String currency,
    Map<String, dynamic>? metadata,
    String? provider, // optional: "visa", "mastercard", "verve", "paycode"
    required BuildContext context,
  }) async {
    try {
      final response = await http
          .post(
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
                if (provider != null) 'provider': provider,
              },
              'metadata': metadata ?? {},
            }),
          )
          .timeout(const Duration(seconds: 20)); // Timeout added here

      Navigator.of(context).pop(); // Dismiss loading

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.showSuccess(context, "Payment successful");
        return ChargeResponse.fromJson(responseData);
      } else {
        final errorMessage =
            responseData['message'] ?? "An unknown error occurred";
        CustomSnackbar.showError(context, "QR Payment failed: $errorMessage");
        throw Exception("QR Payment failed: $errorMessage");
      }
    } on SocketException {
      Navigator.of(context).pop();
      CustomSnackbar.showError(
          context, "No internet connection. Please try again.");
      throw Exception("No internet connection.");
    } on TimeoutException {
      Navigator.of(context).pop();
      CustomSnackbar.showError(context, "Request timed out. Please try again.");
      throw Exception("Request timed out.");
    } on FormatException {
      Navigator.of(context).pop();
      CustomSnackbar.showError(context, "Invalid response from server.");
      throw Exception("Invalid response format.");
    } catch (e) {
      Navigator.of(context).pop();
      CustomSnackbar.showError(context, "Unexpected error: ${e.toString()}");
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}
