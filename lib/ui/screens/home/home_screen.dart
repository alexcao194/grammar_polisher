import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/ai_function.dart';
import '../../../data/models/check_grammar_result.dart';
import '../../../data/models/check_level_result.dart';
import '../../../data/models/check_score_result.dart';
import '../../../data/models/check_writing_result.dart';
import '../../../data/models/detect_gpt_result.dart';
import '../../../data/models/improve_writing_result.dart';
import '../../../data/models/score_type.dart';
import '../../../utils/ads_tools.dart';
import '../../../utils/app_snack_bar.dart';
import '../../commons/banner_ads.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/function_picker_dialog.dart';
import '../../commons/rounded_button.dart';
import 'bloc/home_bloc.dart';
import 'widgets/check_grammar_box.dart';
import 'widgets/check_level_box.dart';
import 'widgets/check_score_box.dart';
import 'widgets/check_writing_box.dart';
import 'widgets/detect_gpt_box.dart';
import 'widgets/improving_writing_box.dart';
import 'widgets/score_type_picker.dart';
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
  ScoreType _selectedScoreType = ScoreType.opinion;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current.result != previous.result,
      listener: (context, state) {
        _count++;
        if (_count % 2 == 0) {
          _count = 0;
          AdsTools.requestNewInterstitial();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            BasePage(
              title: 'Grammarly AI',
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Write your content here\nWe\'ll help you improve it',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
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
                        child: ListTile(
                          title: Text(
                            _selectedFunction.name,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedFunction == AIFunction.checkScore) ...[
                      ScoreTypePicker(
                        onChanged: (value) {
                          setState(() {
                            _selectedScoreType = value;
                          });
                        },
                        selectedScoreType: _selectedScoreType,
                      ),
                      const SizedBox(height: 16),
                    ],
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
                    BannerAds(),
                    const SizedBox(height: 8),
                    if (state.result is ImproveWritingResult) ImprovingWritingBox(result: state.result as ImproveWritingResult),
                    if (state.result is CheckGrammarResult) CheckGrammarBox(result: state.result as CheckGrammarResult),
                    if (state.result is DetectGptResult) DetectGptBox(result: state.result as DetectGptResult),
                    if (state.result is CheckLevelResult) CheckLevelBox(result: state.result as CheckLevelResult),
                    if (state.result is CheckScoreResult) CheckScoreBox(result: state.result as CheckScoreResult),
                    if (state.result is CheckWritingResult) CheckWritingBox(result: state.result as CheckWritingResult),
                    if (state.result != null) ...[
                      const SizedBox(height: 8),
                      BannerAds(),
                    ]
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
    final content = _textController.text;
    switch (_selectedFunction) {
      case AIFunction.improveWriting:
        context.read<HomeBloc>().add(HomeEvent.improveWriting(content));
        break;
      case AIFunction.checkGrammar:
        context.read<HomeBloc>().add(HomeEvent.checkGrammar(content));
        break;
      case AIFunction.detectChatGPT:
        context.read<HomeBloc>().add(HomeEvent.detectGpt(content));
        break;
      case AIFunction.checkLevel:
        context.read<HomeBloc>().add(HomeEvent.checkLevel(content));
        break;
      case AIFunction.checkScore:
        context.read<HomeBloc>().add(HomeEvent.checkScore(text: content, type: _selectedScoreType.code));
        break;
      case AIFunction.checkWriting:
        context.read<HomeBloc>().add(HomeEvent.checkWriting(content));
        break;
    }
  }
}
