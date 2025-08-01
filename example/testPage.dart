import 'package:flutter/material.dart';
import 'package:paystack_flutter/paystack_flutter.dart';
import 'package:paystack_flutter/services/ussd_payment.dart';

class MyPayPage extends StatefulWidget {
  const MyPayPage({super.key});

  @override
  State<MyPayPage> createState() => _MyPayPageState();
}

class _MyPayPageState extends State<MyPayPage> {
  bool _isLoading = false;
  String? _response;

  void _makePayment() async {
    setState(() {
      _isLoading = true;
      _response = null;
    });

    final result = await PaystackFlutter.ussd(
      context: context,
      secretKey: "sk_test_xxxx", // replace with your key
      email: "user@example.com",
      amount: 10000, // amount in kobo (100.00 NGN)
      provider: USSDProvider.sterling, // or USSDProvider.uba etc.
      currency: "NGN",
      metadata: {"orderId": "12345"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with Paystack")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: _makePayment,
                child: const Text("Pay \$100"),
              ),
              if (_response != null) ...[
                const SizedBox(height: 20),
                Text(
                  _response!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
