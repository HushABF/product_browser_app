import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

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
            text: 'Already have an account? ',
            style: TextStyles.font15GrayRegular,
          ),
          TextSpan(
            text: 'Sign in',
            style: TextStyles.font14DarkBlueSemiBold.copyWith(
              color: ColorsManager.mainIndigo,
            ),
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
