import 'package:flutter/material.dart';

import '../../../../data/models/score_type.dart';

class ScoreTypePicker extends StatefulWidget {
  final Function(ScoreType) onChanged;
  final ScoreType selectedScoreType;

  const ScoreTypePicker({
    super.key,
    required this.onChanged,
    required this.selectedScoreType,
  });

  @override
  State<ScoreTypePicker> createState() => _ScoreTypePickerState();
}

class _ScoreTypePickerState extends State<ScoreTypePicker> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _isExpanded ? _buildExpanded() : _buildCollapsed(),
    );
  }

  Widget _buildExpanded() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: List.generate(ScoreType.values.length, (index) {
        final scoreType = ScoreType.values[index];
        return ListTile(
          title: Text(
            scoreType.name,
            style: TextStyle(
              color: widget.selectedScoreType == scoreType
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withAlpha(100),
            ),
          ),
          onTap: () {
            widget.onChanged(scoreType);
            setState(() {
              _isExpanded = false;
            });
          },
        );
      }),
    );
  }

  Widget _buildCollapsed() {
    return ListTile(
      title: Text(widget.selectedScoreType.name),
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
    );
  }
}
