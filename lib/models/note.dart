class Note {
  final int id;
  final int cardId;
  final String content;

  static const String kTable = 'Notes';
  static const String kId = 'id';
  static const String kCardId = 'card_id';
  static const String kContent = 'content';

  Note({
    required this.id,
    required this.cardId,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kCardId: cardId,
      kContent: content
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[kId],
      cardId: map[kCardId],
      content: map[kContent],
    );
  }
}