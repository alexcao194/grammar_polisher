part of 'positioned_flash_card.dart';

class SideCard extends StatelessWidget {
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
        child: isFront ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(
              word.word,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isFront ? colorScheme.onPrimaryContainer : colorScheme.onTertiaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SelectableText(
              word.phoneticText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isFront ? colorScheme.onPrimaryContainer : colorScheme.onTertiaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ) : SelectableText(
          word.senses.firstOrNull?.definition ?? '',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isFront ? colorScheme.onPrimaryContainer : colorScheme.onTertiaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _getCardColor(ColorScheme colorScheme) {
    if (status != null) {
      return Colors.red;
    }
    return isFront ? colorScheme.primaryContainer : colorScheme.tertiaryContainer;
  }
}
