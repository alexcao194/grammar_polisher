enum ScoreType {
  opinion,
  argument,
  filmAnalysis,
  literaryCritique;

  String get name {
    switch (this) {
      case ScoreType.opinion:
        return 'Opinion';
      case ScoreType.argument:
        return 'Argument';
      case ScoreType.filmAnalysis:
        return 'Film Analysis';
      case ScoreType.literaryCritique:
        return 'Literary Critique';
    }
  }

  String get code {
    switch (this) {
      case ScoreType.opinion:
        return 't2-opinion essay';
      case ScoreType.argument:
        return 't2-argument essay';
      case ScoreType.filmAnalysis:
        return 't2-film analysis essay';
      case ScoreType.literaryCritique:
        return 't2-literary critique essay';
    }
  }
}