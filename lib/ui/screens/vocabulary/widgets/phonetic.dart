import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grammar_polisher/configs/di.dart';

import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class Phonetic extends StatefulWidget {
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
  State<Phonetic> createState() => _PhoneticState();
}

class _PhoneticState extends State<Phonetic> {
  final _player = DI().sl<AudioPlayer>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgButton(
          svg: Assets.svgVolumeUp,
          backgroundColor: widget.backgroundColor,
          color: Colors.white,
          size: 16,
          onPressed: _playSound,
        ),
        const SizedBox(width: 8),
        Text(
          widget.phoneticText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _playSound() async {
    if (_player.state == PlayerState.playing) {
      return;
    }
    await _player.play(UrlSource(widget.phonetic));
  }
}
