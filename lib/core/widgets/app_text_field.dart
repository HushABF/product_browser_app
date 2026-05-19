import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final String? label;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? Function(String?) validator;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.label,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!.toUpperCase(), style: TextStyles.font11LightGraySemiBold),
          SizedBox(height: 6.h),
        ],
        TextFormField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              focusedBorder:
                  focusedBorder ??
                  OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsManager.mainIndigo,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
              enabledBorder:
                  enabledBorder ??
                  OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsManager.lighterGray,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorsManager.error),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorsManager.error,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              hintStyle:
                  hintStyle ??
                  TextStyles.font15GrayRegular.copyWith(
                    color: ColorsManager.lighterGray,
                  ),
              hintText: hintText,
              suffixIcon: suffixIcon,
              fillColor: backgroundColor ?? ColorsManager.backgroundWhite,
              filled: true,
            ),
            obscureText: isObscureText ?? false,
            style:
                inputTextStyle ??
                TextStyles.font15GrayRegular.copyWith(
                  color: ColorsManager.darkBlue,
                ),
            validator: (value) => validator(value),
          ),
      ],
    );
  }
}
