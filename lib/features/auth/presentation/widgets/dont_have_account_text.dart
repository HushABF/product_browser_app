import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DontHaveAccountText extends StatefulWidget {
  const DontHaveAccountText({super.key});

  @override
  State<DontHaveAccountText> createState() => _DontHaveAccountTextState();
}

class _DontHaveAccountTextState extends State<DontHaveAccountText> {
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
            text: 'Dont have an account?',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: ' Create one.',
            style: TextStyle(color: Colors.blue),
            recognizer: tapGestureRecognizer
              ..onTap = () {
                context.push('/register');
              },
          ),
        ],
      ),
    );
  }
}
