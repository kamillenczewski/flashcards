class EnglishCard {
  final int id;
  final String word;
  final String explanation;

  static const String kTable = 'Cards';
  static const String kId = 'id';
  static const String kWord = 'word';
  static const String kExplanation = 'explanation';

  static final defaultInstance = EnglishCard(
    id: -1,
    word: 'Default',
    explanation: 'Default',
  );

  EnglishCard({
    required this.id,
    required this.word,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kWord: word,
      kExplanation: explanation
    };
  }

  factory EnglishCard.fromMap(Map<String, dynamic> map) {
    return EnglishCard(
      id: map[kId],
      explanation: map[kExplanation],
      word: map[kWord],
    );
  }
}