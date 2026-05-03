import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlreadyHaveAccountText extends StatefulWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  State<AlreadyHaveAccountText> createState() => _AlreadyHaveAccountTextState();
}

class _AlreadyHaveAccountTextState extends State<AlreadyHaveAccountText> {
  final tapGestureRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account?',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: ' Login.',
            style: TextStyle(color: Colors.blue),
            recognizer: tapGestureRecognizer
              ..onTap = () {
                context.go('/login');
              },
          ),
        ],
      ),
    );
  }
}
