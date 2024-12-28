import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/vocabulary_bloc.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<VocabularyBloc>().add(const VocabularyEvent.getAllOxfordWords());
    return const Placeholder();
  }
}
