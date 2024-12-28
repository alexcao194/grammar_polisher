import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class Phonetic extends StatelessWidget {
  final String phonetic;
  final String phoneticText;
  final Color backgroundColor;

  const Phonetic({
    super.key,
    required this.phonetic,
    required this.phoneticText,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgButton(
          svg: Assets.svgVolumeUp,
          backgroundColor: backgroundColor,
          color: Colors.white,
          size: 16,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        Text(
          phoneticText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
