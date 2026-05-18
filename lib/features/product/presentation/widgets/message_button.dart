import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: ColorsManager.mainIndigo,
      ),
      child: IconButton(
        color: Colors.white,
        iconSize: 20.sp,
        onPressed: () => context.pushNamed('chat', extra: product),
        icon: const Icon(Icons.chat),
      ),
    );
  }
}
