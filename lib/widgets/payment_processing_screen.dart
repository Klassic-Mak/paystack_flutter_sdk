import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:paystack_flutter/model/payment_data.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final Future<PaymentData> Function() process;
  final void Function(PaymentData data)? onSuccess;
  final void Function(String error)? onFailure;

  const PaymentProcessingScreen({
    super.key,
    required this.process,
    this.onSuccess,
    this.onFailure,
  });

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _startProcess();
  }

  Future<void> _startProcess() async {
    try {
      final data = await widget.process();
      widget.onSuccess?.call(data);
      Navigator.of(context).pop();
    } catch (e) {
      widget.onFailure?.call(e.toString());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor ?? Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(), // cancel button
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2,
            ),
            const SizedBox(height: 16),
            const Text("Processing Payment...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SvgPicture.asset(
                'assets/paystack_logo.svg',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
