import 'package:flutter/material.dart';

import '../rounded_button.dart';

class UserDefinitionDialog extends StatefulWidget {
  final String word;
  final bool alreadyDefined;
  final void Function(String? definition) onSave;

  const UserDefinitionDialog({
    super.key,
    required this.word,
    required this.onSave,
    required this.alreadyDefined,
  });

  @override
  State<UserDefinitionDialog> createState() => _UserDefinitionDialogState();
}

class _UserDefinitionDialogState extends State<UserDefinitionDialog> {
  late final TextEditingController _definitionController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Define "${widget.word}"',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
              controller: _definitionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: colorScheme.primaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.alreadyDefined) ...[
              Text(
                'Or',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              RoundedButton(
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: _deleteDefinition,
                backgroundColor: colorScheme.error,
                child: Text(
                  'Delete custom definition',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onError,
                  ),
                ),
              )
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: _onCancel,
                    backgroundColor: colorScheme.secondary,
                    child: Text(
                      'Cancel',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RoundedButton(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: _onSave,
                    child: Text(
                      'Save',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _definitionController = TextEditingController();
  }

  @override
  void dispose() {
    _definitionController.dispose();
    super.dispose();
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onSave() {
    widget.onSave(_definitionController.text);
    Navigator.of(context).pop();
  }

  void _deleteDefinition() {
    widget.onSave(null);
    Navigator.of(context).pop();
  }
}
