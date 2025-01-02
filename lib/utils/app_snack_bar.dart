import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../generated/assets.dart';
import '../ui/commons/svg_button.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const CustomSnackBar({
    super.key,
    required this.message,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: isSuccess ? Color(0xFF0C762A) : Color(0xFFC33B3B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SvgPicture.asset(
            (isSuccess ? Assets.svgSuccess : Assets.svgError),
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SvgButton(
            svg: Assets.svgClose,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          )
        ],
      ),
    );
  }
}

class AppSnackBar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(12),
        content: CustomSnackBar(
          message: message,
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(12),
        content: CustomSnackBar(
          message: message,
          isSuccess: true,
        ),
      ),
    );
  }
}
