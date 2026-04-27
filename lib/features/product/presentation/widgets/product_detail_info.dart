import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/cart_action_button.dart';
import 'package:product_browser_app/features/product/presentation/widgets/message_counter_bloc_builder.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Rating: ${product.rating}',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(product.description, style: textTheme.bodyMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: .center,
            children: [
              CartActionButton(product: product),
              SizedBox(width: 16),
              BlocProvider(
                create: (context) =>
                    getIt<MessageCounterCubit>()..watch(product.id.toString()),
                child: MessageCounterBlocBuilder(product: product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
