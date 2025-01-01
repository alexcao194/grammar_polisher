import 'package:flutter/material.dart';

import 'wheel_picker.dart';

class TimePicker extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool hasHour;
  final bool hasMinute;
  final bool hasPeriod;
  final bool isExpanded;
  final VoidCallback? onTap;

  const TimePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.hasHour = true,
    this.hasMinute = true,
    this.hasPeriod = true,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String _hour = "";
  String _minute = "";
  String _period = "";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: widget.isExpanded ? 200 : 60,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.isExpanded
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.hasHour) WheelPicker(
                        min: 0,
                        max: 23,
                        numberLength: 2,
                        initialItem: int.parse(_hour),
                        onSelectedItemChanged: (value) {
                          _onChange(
                            hour: value,
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      if (widget.hasMinute) WheelPicker(
                        min: 0,
                        max: 59,
                        initialItem: int.parse(_minute),
                        numberLength: 2,
                        onSelectedItemChanged: (value) {
                          _onChange(
                            minute: value,
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      if (widget.hasPeriod) WheelPicker(
                        min: 0,
                        max: 1,
                        initialItem: _period == "AM" ? 0 : 1,
                        mapValues: const [
                          "AM",
                          "PM",
                        ],
                        onSelectedItemChanged: (value) {
                          _onChange(
                            period: value,
                          );
                        },
                      )
                    ],
                  ),
                  Container(
                    height: 32,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.onPrimaryContainer,
                        ),
                        bottom: BorderSide(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: Text(
                  widget.value,
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      final time = widget.value.replaceAll(" ", ":").split(":");
      int index = 0;
      if (widget.hasHour) {
        _hour = time[index++];
      }
      if (widget.hasMinute) {
        _minute = time[index++];
      }
      if (widget.hasPeriod) {
        _period = time[index];
      }
    });
  }

  _onChange({String? hour, String? minute, String? period}) {
    setState(() {
      if (hour != null) {
        _hour = hour;
      }
      if (minute != null) {
        _minute = minute;
      }
      if (period != null) {
        _period = period;
      }
    });
    String time = "";
    if (widget.hasHour) {
      time += _hour;
    }
    if (widget.hasMinute) {
      if (time.isNotEmpty) {
        time += ":";
      }
      time += _minute;
    }
    if (widget.hasPeriod) {
      if (time.isNotEmpty) {
        time += " ";
      }
      time += _period;
    }
    widget.onChanged(time);
  }
}
