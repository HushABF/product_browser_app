import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.splashBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: ColorsManager.mainIndigo,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  'H',
                  style: TextStyles.font44DarkBlueBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Hush Market',
              style: TextStyles.font28DarkBlueBold.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'QUIET COMMERCE',
              style: TextStyles.font12LightGrayMedium.copyWith(
                color: ColorsManager.lighterGray,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 48.h),
            SizedBox(
              width: 200.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  backgroundColor: const Color(0xFF2A2730),
                  color: ColorsManager.mainIndigo,
                  minHeight: 3.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
