import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/message_button.dart';

class MessageCounterBlocBuilder extends StatelessWidget {
  const MessageCounterBlocBuilder({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCounterCubit, MessageCounterState>(
      builder: (context, state) {
        final count = state is MessageCounterLoaded ? state.count : 0;
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: -5, end: -8),
          showBadge: state is MessageCounterLoaded && count > 0,
          badgeAnimation: const badges.BadgeAnimation.slide(toAnimate: false),
          badgeContent: Text(
            '$count',
            style: TextStyles.font12LightGrayMedium.copyWith(
              color: Colors.white,
              fontSize: 10.sp,
            ),
          ),
          child: MessageButton(product: product),
        );
      },
    );
  }
}
