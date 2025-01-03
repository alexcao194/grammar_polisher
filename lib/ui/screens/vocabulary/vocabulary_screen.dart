import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/word_pos.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../utils/ads_tools.dart';
import '../../commons/banner_ads.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/word_details_dialog.dart';
import '../../commons/svg_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/search_box.dart';
import 'widgets/vocabulary_item.dart';

class VocabularyScreen extends StatefulWidget {
  final int? wordId;

  const VocabularyScreen({super.key, this.wordId});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  bool _showSearch = false;
  final List<WordPos> _selectedPos = [];
  List<WordStatus> _selectedStatus = [];
  String? _selectedLetter;
  String _searchText = '';

  int _notificationCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VocabularyBloc, VocabularyState>(
      listener: (context, state) {
        _showWordDetails();
      },
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBox(
                showSearch: _showSearch,
                selectedPos: _selectedPos,
                selectedLetter: _selectedLetter,
                selectedStatus: _selectedStatus,
                onSelectPos: _onSelectPos,
                onSelectLetter: _onSelectLetter,
                onClearFilters: _onClearFilters,
                onSearch: _onSearch,
                onSelectStatus: _onSelectStatus,
              ),
              GestureDetector(
                onTap: _onShowSearch,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${_getFilterLabel()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return VocabularyItem(
                      word: word,
                      onReminder: _onReminder,
                    );
                  },
                ),
              ),
              BannerAds(),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _showWordDetails();
    _listenNotificationsBloc();
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

  void _onSelectStatus(WordStatus status) {
    setState(() {
      if (_selectedStatus.contains(status)) {
        _selectedStatus.remove(status);
      } else {
        _selectedStatus.add(status);
      }
    });
  }

  void _onClearFilters() {
    setState(() {
      _selectedPos.clear();
      _selectedLetter = null;
      _selectedStatus.clear();
      _searchText = '';
      _showSearch = false;
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
      final containsStatus = _selectedStatus.isEmpty || _selectedStatus.contains(word.status);
      return containsPos && containsLetter && containsSearchText && containsStatus;
    }).toList();
  }

  _showWordDetails() {
    final notificationsBloc = context.read<NotificationsBloc>();
    final wordId = widget.wordId ?? notificationsBloc.state.wordIdFromNotification;
    if (wordId != null) {
      context.read<NotificationsBloc>().add(const NotificationsEvent.clearWordIdFromNotification());
      final word = context.read<VocabularyBloc>().state.words.firstWhere(
            (element) => element.index == wordId,
          );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
          context: context,
          builder: (context) => WordDetailsDialog(word: word),
        );
      });
    }
  }

  void _listenNotificationsBloc() {
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.stream.listen((state) {
      if (state.wordIdFromNotification != null) {
        _showWordDetails();
      }
    });
  }

  void _onReminder() {
    _notificationCount++;
    if (_notificationCount == 7) {
      AdsTools.requestNewInterstitial();
      _notificationCount = 0;
    }
  }

  _getFilterLabel() {
    final letter = _selectedLetter != null ? 'letter: ${_selectedLetter?.toLowerCase()}' : '';
    final pos = _selectedPos.isNotEmpty ? 'pos: ${_selectedPos.map((e) => e.name).join(', ')}' : '';
    final status = _selectedStatus.isNotEmpty ? 'status: ${_selectedStatus.map((e) => e.name).join(', ')}' : '';
    final search = _searchText.isNotEmpty ? 'search: $_searchText' : '';
    if (letter.isEmpty && pos.isEmpty && status.isEmpty && search.isEmpty) {
      return 'All words';
    }
    String result = '';
    if (letter.isNotEmpty) {
      result += letter;
    }
    if (pos.isNotEmpty) {
      if (result.isNotEmpty) {
        result += ', ';
      }
      result += pos;
    }
    if (status.isNotEmpty) {
      if (result.isNotEmpty) {
        result += ', ';
      }
      result += status;
    }
    if (search.isNotEmpty) {
      if (result.isNotEmpty) {
        result += ', ';
      }
      result += search;
    }
    return result;
  }
}
