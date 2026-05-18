import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

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
          TextSpan(text: 'New to Hush? ', style: TextStyles.font15GrayRegular),
          TextSpan(
            text: 'Create an account',
            style: TextStyles.font14DarkBlueSemiBold.copyWith(
              color: ColorsManager.mainIndigo,
            ),
            recognizer: tapGestureRecognizer
              ..onTap = () {
                context.go('/register');
              },
          ),
        ],
      ),
    );
  }
}
