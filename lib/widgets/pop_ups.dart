import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      animationPath: 'packages/paystack_flutter/assets/animations/success.json',
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: const Color.fromARGB(255, 223, 0, 0),
      textColor: Colors.white,
      animationPath: 'packages/paystack_flutter/assets/animations/error.json',
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color textColor,
    required String animationPath,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 5),
                SizedBox(
                  height: 42,
                  child: Lottie.asset(animationPath),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
