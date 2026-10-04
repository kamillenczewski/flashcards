class SessionGroupLink {
  final int id;
  final int sessionId;
  final int groupId;

  static const String kTable = 'SessionGroupLinks';
  static const String kId = 'id';
  static const String kSessionId = 'sessionId';
  static const String kGroupId = 'groupId';

  SessionGroupLink({
    required this.id,
    required this.sessionId,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kSessionId: sessionId,
      kGroupId: groupId,
    };
  }

  factory SessionGroupLink.fromMap(Map<String, dynamic> map) {
    return SessionGroupLink(
      id: map[kId],
      sessionId: map[kSessionId],
      groupId: map[kGroupId],
    );
  }
}