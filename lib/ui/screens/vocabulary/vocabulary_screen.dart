import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../commons/base_page.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/vocabulary_item.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        final words = state.words;
        return BasePage(
          title: 'Vocabulary',
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return VocabularyItem(word: word);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(const VocabularyEvent.getAllOxfordWords());
  }
}
