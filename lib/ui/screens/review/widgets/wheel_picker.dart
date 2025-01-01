import 'package:flutter/cupertino.dart';

class WheelPicker extends StatefulWidget {
  final int min;
  final int max;
  final int initialItem;
  final int? numberLength;
  final List<String>? mapValues;
  final ValueChanged<String> onSelectedItemChanged;

  const WheelPicker({
    super.key,
    required this.min,
    required this.max,
    required this.initialItem,
    required this.onSelectedItemChanged,
    this.numberLength,
    this.mapValues,
  });

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  late final ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: 42,
        diameterRatio: 1.4,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                _getValue(index),
              ),
            );
          },
          childCount: widget.max - widget.min + 1,
        ),
        onSelectedItemChanged: (index) {
          widget.onSelectedItemChanged(_getValue(index));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.initialItem - widget.min);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getValue(int index) {
    if (widget.mapValues != null) {
      return widget.mapValues![index];
    }
    final min = widget.min;
    final numberLength = widget.numberLength;
    final value = min + index;
    if (numberLength != null) {
      return index.toString().padLeft(numberLength, '0');
    } else {
      return value.toString();
    }
  }
}
