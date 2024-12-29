import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grammar_polisher/data/models/word.dart';

import '../../../constants/word_pos.dart';
import '../../../generated/assets.dart';
import '../../commons/base_page.dart';
import '../../commons/svg_button.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/search_box.dart';
import 'widgets/vocabulary_item.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  bool _showSearch = false;
  List<WordPos> _selectedPos = [];
  String? _selectedLetter;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        final words = _getFilteredWords(state.words);
        return BasePage(
          title: 'Vocabulary',
          actions: [
            SvgButton(
              svg: _showSearch ? Assets.svgClose : Assets.svgSearch,
              onPressed: _onShowSearch,
            )
          ],
          child: Column(
            children: [
              SearchBox(
                showSearch: _showSearch,
                selectedPos: _selectedPos,
                onSelectPos: _onSelectPos,
                selectedLetter: _selectedLetter,
                onSelectLetter: _onSelectLetter,
                onClearFilters: _onClearFilters,
                onSearch: _onSearch,
              ),
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

  void _onShowSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void _onSelectPos(WordPos pos) {
    setState(() {
      if (_selectedPos.contains(pos)) {
        _selectedPos.remove(pos);
      } else {
        _selectedPos.add(pos);
      }
    });
  }

  void _onSelectLetter(String? letter) {
    setState(() {
      _selectedLetter = letter;
    });
  }

  void _onClearFilters() {
    setState(() {
      _selectedPos.clear();
      _selectedLetter = null;
    });
  }

  void _onSearch(String text) {
    setState(() {
      _searchText = text;
    });
  }

  _getFilteredWords(List<Word> words) {
    return words.where((word) {
      final pos = word.pos.split(', ');
      final containsPos = _selectedPos.isEmpty || pos.any((p) => _selectedPos.contains(WordPos.fromString(p)));
      final containsLetter = _selectedLetter == null || word.word.toLowerCase().startsWith(_selectedLetter!.toLowerCase());
      final containsSearchText = _searchText.isEmpty || word.word.toLowerCase().contains(_searchText.toLowerCase());
      return containsPos && containsLetter && containsSearchText;
    }).toList();
  }
}
