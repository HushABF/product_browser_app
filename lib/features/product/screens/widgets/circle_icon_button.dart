import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Widget child;

  const CircleIconButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black26,
      ),
      child: child,
    );
  }
}
