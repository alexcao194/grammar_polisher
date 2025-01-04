import 'package:flutter/material.dart';

import '../../generated/assets.dart';
import 'svg_button.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const AppHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
      child: Stack(
        children: [
          Center(child: Text(title, style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ))),
          Row(
            children: [
              if (Navigator.of(context).canPop())
                SvgButton(
                  svg: Assets.svgArrowBackIos,
                  color: colorScheme.primary,
                  onPressed: () => _onClose(context),
                ),
              const Spacer(),
              ...actions,
            ],
          ),
        ],
      ),
    );
  }

  _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }
}
