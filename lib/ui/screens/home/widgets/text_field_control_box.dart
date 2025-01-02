import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class TextFieldControlBox extends StatelessWidget {
  final TextEditingController controller;

  const TextFieldControlBox({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgButton(
          svg: Assets.svgCopy,
          onPressed: _onCopy,
        ),
        const SizedBox(width: 16),
        SvgButton(
          svg: Assets.svgPaste,
          onPressed: _onPaste,
        ),
        const SizedBox(width: 16),
        SvgButton(
          svg: Assets.svgClear,
          onPressed: _onDelete,
        ),
        // const SizedBox(width: 16),
        // SvgButton(
        //   svg: Assets.svgMic,
        //   onPressed: _onMic,
        // ),
      ],
    );
  }

  void _onCopy() async {
    if (controller.text.isEmpty) {
      return;
    }
    final clipboardData = ClipboardData(text: controller.text);
    await Clipboard.setData(clipboardData);
  }

  void _onPaste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      controller.text = clipboardData.text ?? '';
    }
  }

  void _onDelete() {
    if (controller.text.isEmpty) {
      return;
    }
    controller.clear();
  }

  void _onMic() {}
}
