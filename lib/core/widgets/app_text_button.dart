import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

class AppTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? buttonWidth;
  final double? buttonHeight;

  const AppTextButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.buttonWidth,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? ColorsManager.mainIndigo,
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16.w),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(buttonWidth ?? double.maxFinite, buttonHeight ?? 44.h),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: textStyle ??
            TextStyles.font14DarkBlueSemiBold.copyWith(color: Colors.white),
      ),
    );
  }
}
