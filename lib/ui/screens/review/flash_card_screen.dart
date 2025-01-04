import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grammar_polisher/ui/screens/vocabulary/bloc/vocabulary_bloc.dart';

import '../../../constants/custom_colors.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_snack_bar.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import 'widgets/positioned_flash_card.dart';

class FlashCardScreen extends StatefulWidget {
  final List<Word> words;

  const FlashCardScreen({super.key, required this.words});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  final List<Word> _words = [];
  final List<PositionedFlashCardController> _controllers = [];
  bool _animating = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return BasePage(
      title: 'Flashcards',
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size.width * 0.9,
            child: Stack(
              children: List.generate(
                _words.length,
                (index) {
                  final word = _words[index];
                  return PositionedFlashCard(
                    key: ValueKey(word.index),
                    controller: _controllers[index],
                    display: index == _words.length - 1 || index == _words.length - 2 || index == _words.length - 3,
                    word: word,
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    backgroundColor: CustomColors.red,
                    onPressed: _onCheckBack,
                    borderRadius: 16,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgUndo,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Check back",
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RoundedButton(
                    backgroundColor: CustomColors.green,
                    onPressed: _onMastered,
                    borderRadius: 16,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgCheck,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Mastered",
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _words.addAll(widget.words);
    _controllers.addAll(List.generate(widget.words.length, (index) => PositionedFlashCardController()));
  }

  void _onCheckBack() async {
    if (_animating) {
      return;
    }
    if (_words.length == 1) {
      AppSnackBar.showError(context, "You can't check back the last word");
      return;
    }
    _animating = true;
    await _controllers.last.checkBack();
    setState(() {
      _words.insert(0, _words.removeLast());
      _controllers.insert(0, _controllers.removeLast());
    });
    _animating = false;
  }

  void _onMastered() async {
    if (_animating) {
      return;
    }
    _animating = true;
    await _controllers.last.mastered();
    late Word masteredWord;
    setState(() {
      masteredWord = _words.removeLast();
      _controllers.removeLast();
    });
    if (mounted) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(masteredWord, WordStatus.mastered));
      if (_words.isEmpty) {
        Navigator.of(context).pop();
      }
    }
    _animating = false;
  }
}
