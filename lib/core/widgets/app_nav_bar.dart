import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;

  const AppNavBar({super.key, this.leading, this.title, this.trailing});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: ColorsManager.backgroundWhite,
      child: Row(
        children: [
          ?leading,
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: TextStyles.font17DarkBlueSemiBold,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}
