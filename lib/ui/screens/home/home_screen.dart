import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/ai_function.dart';
import '../../../data/models/check_grammar_result.dart';
import '../../../data/models/improve_writing_result.dart';
import '../../../utils/app_snack_bar.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/function_picker_dialog.dart';
import '../../commons/rounded_button.dart';
import 'bloc/home_bloc.dart';
import 'widgets/check_grammar_box.dart';
import 'widgets/improving_writing_box.dart';
import 'widgets/text_field_control_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _textController;
  late final FocusNode _textFocusNode;
  AIFunction _selectedFunction = AIFunction.improveWriting;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Stack(
          children: [
            BasePage(
              title: 'Home',
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Write your content here\nWe\'ll polish it for you',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      focusNode: _textFocusNode,
                      minLines: 5,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: 'Write your content here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFieldControlBox(
                      controller: _textController,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _onShowFunctionDialog,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _selectedFunction.name,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RoundedButton(
                      borderRadius: 16,
                      onPressed: _processContent,
                      child: Text(
                        'Process',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.result is ImproveWritingResult) ImprovingWritingBox(result: state.result as ImproveWritingResult),
                    if (state.result is CheckGrammarResult) CheckGrammarBox(result: state.result as CheckGrammarResult),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onShowFunctionDialog() {
    showDialog(
      context: context,
      builder: (context) => FunctionPickerDialog(
        onChanged: _onFunctionChanged,
      ),
    );
  }

  _onFunctionChanged(AIFunction value) {
    setState(() {
      _selectedFunction = value;
    });
  }

  void _processContent() {
    _textFocusNode.unfocus();
    if (_textController.text.isEmpty) {
      AppSnackBar.showError(context, 'Please write some content');
      return;
    }
    switch (_selectedFunction) {
      case AIFunction.improveWriting:
        context.read<HomeBloc>().add(HomeEvent.improveWriting(_textController.text));
        break;
      case AIFunction.checkGrammar:
        context.read<HomeBloc>().add(HomeEvent.checkGrammar(_textController.text));
        break;
      default:
        break;
    }
  }
}
