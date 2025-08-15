import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/widgets/pop_ups.dart';

class DirectDebitBankService {
  static Future<Map<String, dynamic>> initiate({
    required BuildContext context,
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

    try {
      final response = await http
          .post(
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
          )
          .timeout(const Duration(seconds: 15)); // ⏱ Timeout

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.showSuccess(
            context, "Direct debit initiated successfully.");
        return responseData;
      } else {
        // Defensive extraction of error message
        String errorMessage = 'An unknown error occurred';
        if (responseData is Map && responseData.containsKey('message')) {
          final msg = responseData['message'];
          if (msg is String && msg.isNotEmpty) {
            errorMessage = msg;
          } else if (msg != null) {
            errorMessage = msg.toString();
          }
        }
        CustomSnackbar.showError(context, "Direct debit failed: $errorMessage");
        throw Exception("Direct debit failed: $errorMessage");
      }
    } on SocketException {
      CustomSnackbar.showError(
          context, "No internet connection. Please check your network.");
      throw Exception("No internet connection.");
    } on TimeoutException {
      CustomSnackbar.showError(context, "Request timed out. Please try again.");
      throw Exception("Request timed out.");
    } on FormatException {
      CustomSnackbar.showError(context, "Invalid response format from server.");
      throw Exception("Invalid response format.");
    } catch (e) {
      CustomSnackbar.showError(context, "Unexpected error: ${e.toString()}");
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}
