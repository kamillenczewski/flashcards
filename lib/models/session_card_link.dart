class SessionCardLink {
  final int id;
  final int sessionId;
  final int cardId;

  static const String kTable = 'SessionCardLinks';
  static const String kId = 'id';
  static const String kSessionId = 'sessionId';
  static const String kCardId = 'cardId';

  SessionCardLink({
    required this.id,
    required this.sessionId,
    required this.cardId,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kSessionId: sessionId,
      kCardId: cardId,
    };
  }

  factory SessionCardLink.fromMap(Map<String, dynamic> map) {
    return SessionCardLink(
      id: map[kId],
      sessionId: map[kSessionId],
      cardId: map[kCardId],
    );
  }
}