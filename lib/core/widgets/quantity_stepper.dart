import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.lighterGray),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: onDecrement,
          ),
          SizedBox(
            width: 36.w,
            child: Text(
              '$quantity',
              style: TextStyles.font14DarkBlueSemiBold,
              textAlign: TextAlign.center,
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 36.w,
        height: 36.h,
        child: Icon(icon, size: 18.sp, color: ColorsManager.gray),
      ),
    );
  }
}
