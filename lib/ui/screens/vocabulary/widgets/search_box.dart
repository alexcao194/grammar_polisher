import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/word_pos.dart';
import '../../../../data/models/word_status.dart';
import '../../../../generated/assets.dart';

class SearchBox extends StatefulWidget {
  final bool showSearch;
  final void Function(WordPos)? onSelectPos;
  final void Function(String)? onSearch;
  final List<WordPos> selectedPos;
  final String? selectedLetter;
  final void Function(String?)? onSelectLetter;
  final VoidCallback? onClearFilters;
  final List<WordStatus> selectedStatus;
  final void Function(WordStatus)? onSelectStatus;

  const SearchBox({
    super.key,
    required this.showSearch,
    required this.selectedPos,
    required this.selectedStatus,
    this.onSelectPos,
    this.onSearch,
    this.selectedLetter,
    this.onSelectLetter,
    this.onClearFilters,
    this.onSelectStatus,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.showSearch ? 238 : 0,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: widget.onSearch,
              onSubmitted: widget.onSearch,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text("Word Pos: "),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: WordPos.values.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final pos = WordPos.values[index];
                        final selected = widget.selectedPos.contains(pos);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: selected,
                            selectedColor: pos.color,
                            checkmarkColor: Colors.white,
                            label: Text(
                              pos.value,
                              style: textTheme.titleSmall?.copyWith(
                                color: selected ? Colors.white : colorScheme.onPrimaryContainer,
                              ),
                            ),
                            onSelected: (selected) => widget.onSelectPos?.call(pos),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text("Letter: "),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 26,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final letter = String.fromCharCode(65 + index);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: widget.selectedLetter == letter,
                            label: Text(
                              letter,
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                widget.onSelectLetter?.call(letter);
                              } else {
                                widget.onSelectLetter?.call(null);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text("Status : "),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: WordStatus.values.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final status = WordStatus.values[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: widget.selectedStatus.contains(status),
                            label: Text(
                              status.value,
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            onSelected: (selected) => widget.onSelectStatus?.call(status),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: widget.onClearFilters,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    Assets.svgClear,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Clear Filters",
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
