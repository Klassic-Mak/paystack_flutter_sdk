import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/paystack_request_response.dart';
import 'package:paystack_flutter/widgets/pop_ups.dart'; // Ensure CustomSnackbar is defined here

// Enum for common Nigerian USSD providers
enum USSDProvider {
  gtBank, // *737#
  uba, // *919#
  sterling, // *822#
  zenith, // *966#
}

class USSDPaymentService {
  static Future<ChargeResponse> initialize({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required String currency,
    required USSDProvider provider,
    Map<String, dynamic>? metadata,
  }) async {
    final String ussdType = _getUSSDCode(provider);

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
              'ussd': {'type': ussdType},
              'metadata': metadata ?? {},
            }),
          )
          .timeout(const Duration(seconds: 15));

      final responseData = jsonDecode(response.body);
      print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bool paystackStatus = responseData['status'] == true;

        if (paystackStatus) {
          CustomSnackbar.showSuccess(
            context,
            responseData['message']?.toString() ?? "USSD charge initiated.",
          );
          return ChargeResponse.fromJson(responseData);
        } else {
          final errorMessage =
              responseData['message']?.toString() ?? "Something went wrong";
          CustomSnackbar.showError(
              context, "USSD Payment failed: $errorMessage");
          throw Exception("USSD Payment failed: $errorMessage");
        }
      } else {
        final errorMessage = responseData['message']?.toString() ??
            "Unexpected response from Paystack";
        CustomSnackbar.showError(context, "USSD Payment failed: $errorMessage");
        throw Exception("USSD Payment failed: $errorMessage");
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
