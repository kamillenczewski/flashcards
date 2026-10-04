class GroupLink {
  final int id;
  final int groupId;
  final int cardId;

  static const String kTable = 'GroupLinks';
  static const String kId = 'id';
  static const String kGroupId = 'groupId';
  static const String kCardId = 'cardId';

  GroupLink({
    required this.id,
    required this.groupId,
    required this.cardId,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kGroupId: groupId,
      kCardId: cardId
    };
  }

  factory GroupLink.fromMap(Map<String, dynamic> map) {
    return GroupLink(
      id: map[kId],
      groupId: map[kGroupId],
      cardId: map[kCardId],
    );
  }
}