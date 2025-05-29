import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final Color? backgroundColor;

  const CardWidget({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = Colors.white;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor ?? defaultBackgroundColor,
        border: Border.all(color: Colors.white60),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}
