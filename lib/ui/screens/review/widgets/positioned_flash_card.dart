import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/word.dart';

part 'side_card.dart';

enum FlashCardStatus { checkBack, mastered }

class PositionedFlashCardController {
  late Future<void> Function() checkBack;
  late Future<void> Function() mastered;
}

class PositionedFlashCard extends StatefulWidget {
  final bool display;
  final Word word;
  final PositionedFlashCardController? controller;

  const PositionedFlashCard({
    super.key,
    required this.display,
    required this.word,
    this.controller,
  });
  static final _animateDuration = const Duration(milliseconds: 500);

  @override
  State<PositionedFlashCard> createState() => _PositionedFlashCardState();
}

class _PositionedFlashCardState extends State<PositionedFlashCard> {
  FlashCardStatus? _status;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final word = widget.word;
    final cardWidth = size.width * 0.7;
    final center = size.width / 2 - cardWidth / 2;
    return AnimatedPositioned(
      left: _status == FlashCardStatus.mastered ? null : (_status == FlashCardStatus.checkBack ? -300 : center),
      right: _status == FlashCardStatus.checkBack ? null : (_status == FlashCardStatus.mastered ? -300 : center),
      duration: PositionedFlashCard._animateDuration,
      curve: Curves.easeInOut,
      child: Visibility(
        visible: widget.display,
        child: FlashCard(
          height: size.width * 0.9,
          width: size.width * 0.7,
          frontWidget: () => SideCard(
            word: word,
            isFront: false,
            status: _status,
          ),
          backWidget: () => SideCard(
            word: word,
            isFront: true,
            status: _status,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.checkBack = _checkBack;
      widget.controller!.mastered = _mastered;
    }
  }

  Future<void> _checkBack() async {
    setState(() {
      _status = FlashCardStatus.checkBack;
    });
    await Future.delayed(PositionedFlashCard._animateDuration);
    setState(() {
      _status = null;
    });
  }

  Future<void> _mastered() async {
    setState(() {
      _status = FlashCardStatus.mastered;
    });
    await Future.delayed(PositionedFlashCard._animateDuration);
    setState(() {
      _status = null;
    });
  }
}
