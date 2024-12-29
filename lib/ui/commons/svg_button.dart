import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  final String svg;
  final double size;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const SvgButton({
    super.key,
    required this.svg,
    this.onPressed,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Padding(
          padding: padding,
          child: SvgPicture.asset(
            height: size,
            svg,
            colorFilter: ColorFilter.mode(
              color ?? colorScheme.onPrimaryContainer,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}