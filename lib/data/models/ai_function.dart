enum AIFunction {
  improveWriting,
  checkGrammar,
  detectChatGPT,
  checkLevel,
  checkScore,
  checkWriting;
  
  String get name {
    switch (this) {
      case AIFunction.improveWriting:
        return 'Improve Writing';
      case AIFunction.checkGrammar:
        return 'Check Grammar';
      case AIFunction.detectChatGPT:
        return 'Detect Chat GPT';
      case AIFunction.checkLevel:
        return 'Check Level';
      case AIFunction.checkScore:
        return 'Check Score';
      case AIFunction.checkWriting:
        return 'Check Writing';
    }
  }
}