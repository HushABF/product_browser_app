import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/message_button.dart';

class MessageCounterBlocBuilder extends StatelessWidget {
  const MessageCounterBlocBuilder({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<MessageCounterCubit, MessageCounterState>(
      builder: (context, state) {
        final count = state is MessageCounterLoaded ? state.count : 0;
        return badges.Badge(
          position: .topEnd(top: -5, end: -8),
          showBadge: state is MessageCounterLoaded && count > 0,
          badgeAnimation: badges.BadgeAnimation.slide(toAnimate: false),
          badgeContent: Text(
            '$count',
            style: textTheme.labelSmall?.copyWith(color: Colors.white),
          ),

          child: MessageButton(colorScheme: colorScheme, product: product),
        );
      },
    );
  }
}
