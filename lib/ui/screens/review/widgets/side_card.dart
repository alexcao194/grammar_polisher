part of 'positioned_flash_card.dart';

class SideCard extends StatefulWidget {
  final bool isFront;
  final Word word;
  final FlashCardStatus? status;

  const SideCard({
    super.key,
    required this.isFront,
    required this.word,
    required this.status,
  });

  @override
  State<SideCard> createState() => _SideCardState();
}

class _SideCardState extends State<SideCard> {
  late final TextEditingController _definitionController;
  late final FocusNode _focusNode;
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(colorScheme),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: widget.isFront
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    widget.word.word,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: widget.isFront ? colorScheme.onPrimaryContainer : colorScheme.onTertiaryContainer,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    widget.word.phoneticText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.isFront ? colorScheme.onPrimaryContainer : colorScheme.onTertiaryContainer,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: _definitionController,
                                focusNode: _focusNode,
                                minLines: 1,
                                maxLines: 5,
                                enabled: _editing,
                                decoration: InputDecoration(border: InputBorder.none),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: widget.isFront ? colorScheme.onPrimaryContainer : colorScheme.onTertiaryContainer,
                                    ),
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_editing) RoundedButton(
                        onPressed: _saveDefinition,
                        padding: const EdgeInsets.all(0),
                        borderRadius: 16,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SvgButton(
                      onPressed: _addDefinition,
                      svg: Assets.svgEdit,
                      color: colorScheme.primary,
                      backgroundColor: Colors.transparent,
                      size: 16,
                    ),
                  )
                ],
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _definitionController = TextEditingController();
    _focusNode = FocusNode();
    final word = widget.word;
    _definitionController.text = word.userDefinition ?? word.senses.firstOrNull?.definition ?? '';
  }

  @override
  void dispose() {
    _definitionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  _getCardColor(ColorScheme colorScheme) {
    if (widget.status != null) {
      return Colors.red;
    }
    return widget.isFront ? colorScheme.primaryContainer : colorScheme.tertiaryContainer;
  }

  void _saveDefinition() {
    setState(() {
      _editing = false;
    });
    if (_definitionController.text.isEmpty) {
      _definitionController.text = widget.word.userDefinition ?? widget.word.senses.firstOrNull?.definition ?? '';
      return;
    }
    context.read<VocabularyBloc>().add(VocabularyEvent.editDefinition(widget.word, _definitionController.text));
  }

  void _addDefinition() {
    setState(() {
      _editing = true;
    });
    _definitionController.text = "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }
}
