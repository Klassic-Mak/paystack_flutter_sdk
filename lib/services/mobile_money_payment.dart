import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';
import 'package:paystack_flutter/widgets/pop_ups.dart'; // ensure this contains CustomSnackbar

class MobileMoneyService {
  static Future<ChargeResponse> charge({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required String currency,
    required String phone,
    required String provider,
    Map<String, dynamic>? metadata,
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
              'amount': amount,
              'email': email,
              'currency': currency,
              'mobile_money': {
                'phone': phone,
                'provider': provider,
              },
              'metadata': metadata ?? {},
            }),
          )
          .timeout(const Duration(seconds: 15)); // ⏱ Timeout

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.showSuccess(
            context, "Mobile Money charge initiated successfully.");
        return ChargeResponse.fromJson(responseData);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Unknown error occurred';
        CustomSnackbar.showError(
            context, "Mobile Money charge failed: $errorMessage");
        throw Exception("Mobile Money charge failed: $errorMessage");
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
