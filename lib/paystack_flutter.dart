library paystack_flutter;

// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_flutter/model/payment_data.dart';
import 'package:paystack_flutter/services/bank_transfer_payment.dart';
import 'package:paystack_flutter/services/direct_debit.dart';
import 'package:paystack_flutter/services/mobile_money_payment.dart';
import 'package:paystack_flutter/services/qr_code_payment.dart';
import 'package:paystack_flutter/services/ussd_payment.dart';
import 'package:paystack_flutter/widgets/payment_processing_screen.dart';
import '../model/paystack_request_response.dart';

class PaystackFlutter {
  // === USSD Payments ===
  static Future<PaymentData?> ussd({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required USSDProvider provider,
    required String currency,
    Map<String, dynamic>? metadata,
    Function(PaymentData)? onSuccess,
    Function(String)? onFailure,
  }) async {
    final result = await Navigator.push<PaymentData>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          process: () async {
            final res = await USSDPaymentService.initialize(
              context: context,
              provider: provider,
              secretKey: secretKey,
              email: email,
              amount: amount,
              currency: currency,
              metadata: metadata,
            );

            return PaymentData(
              reference: res.reference,
              status: res.status ? 'true' : 'false',
              message: res.message,
            );
          },
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      ),
    );

    return result;
  }

  // === Mobile Money ===
  static Future<void> mobileMoney({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required String phone,
    required String provider,
    required String currency,
    Map<String, dynamic>? metadata,
    Function(PaymentData)? onSuccess,
    Function(String)? onFailure,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          process: () async {
            final res = await MobileMoneyService.charge(
              context: context,
              secretKey: secretKey,
              email: email,
              amount: amount,
              phone: phone,
              provider: provider,
              currency: currency,
              metadata: metadata,
            );
            return PaymentData(
              reference: res.reference,
              status: res.status ? 'true' : 'false',
              message: res.message,
            );
          },
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      ),
    );
  }

  // === Bank Debit ===
  static Future<void> bank({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required String accountNumber,
    required String currency,
    Map<String, dynamic>? metadata,
    Function(PaymentData)? onSuccess,
    Function(String)? onFailure,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          process: () async {
            final res = await BankTransferService.initializeTransfer(
              context: context,
              secretKey: secretKey,
              email: email,
              amount: amount,
              currency: currency,
              metadata: metadata,
            );
            return PaymentData(
              reference: res.reference,
              status: res.status ? 'true' : 'false',
              message: res.message,
            );
          },
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      ),
    );
  }

  // === QR Code ===
  static Future<void> qr({
    required BuildContext context,
    required String secretKey,
    required String email,
    required int amount,
    required String currency,
    String? provider,
    Map<String, dynamic>? metadata,
    Function(PaymentData)? onSuccess,
    Function(String)? onFailure,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          process: () async {
            final res = await QRPaymentService.initialize(
              context: context,
              secretKey: secretKey,
              email: email,
              amount: amount,
              currency: currency,
              provider: provider,
              metadata: metadata,
            );
            return PaymentData(
              reference: res.reference,
              status: res.status ? 'true' : 'false',
              message: res.message,
            );
          },
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      ),
    );
  }

  // === Direct Debit ===
  static Future<void> directDebitBank({
    required BuildContext context,
    required String secretKey,
    required String email,
    required String callbackUrl,
    required String accountNumber,
    required String bankCode,
    required String state,
    required String city,
    required String street,
    Function(PaymentData)? onSuccess,
    Function(String)? onFailure,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          process: () async {
            final res = await DirectDebitBankService.initiate(
              context: context,
              secretKey: secretKey,
              email: email,
              callbackUrl: callbackUrl,
              accountNumber: accountNumber,
              bankCode: bankCode,
              state: state,
              city: city,
              street: street,
            );
            return PaymentData(
              reference: res['data']['reference'],
              status: res['data']['status'],
              message: res['message'],
            );
          },
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      ),
    );
  }

  static Future<PaymentData> verifyPayment({
    required String secretKey,
    required String reference,
  }) async {
    final response = await http.get(
      Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PaymentData.fromJson(json['data']);
    } else {
      throw Exception('Transaction verification failed: ${response.body}');
    }
  }
}

//Version 1.0.0
