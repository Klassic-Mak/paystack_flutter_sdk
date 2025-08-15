import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';
import 'package:paystack_flutter/widgets/pop_ups.dart';

class BankTransferService {
  static Future<ChargeResponse> initializeTransfer({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required String currency,
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

    try {
      final response = await http
          .post(
            uri,
            headers: {
              "Authorization": "Bearer $secretKey",
              "Content-Type": "application/json",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.showSuccess(
            context, "Bank Transfer initialized successfully.");
        return ChargeResponse.fromJson(responseData);
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
        CustomSnackbar.showError(
            context, "Bank Transfer failed: $errorMessage");
        throw Exception("Bank Transfer failed: $errorMessage");
      }
    } on SocketException {
      CustomSnackbar.showError(
          context, "No internet connection. Please check your network.");
      throw Exception("No internet connection.");
    } on TimeoutException {
      CustomSnackbar.showError(context, "Request timed out. Please try again.");
      throw Exception("Request timed out.");
    } on FormatException {
      CustomSnackbar.showError(
          context, "Invalid response format from Paystack.");
      throw Exception("Invalid response format.");
    } catch (e) {
      CustomSnackbar.showError(context, "Unexpected error: ${e.toString()}");
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}
