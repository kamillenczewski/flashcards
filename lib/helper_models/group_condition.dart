class GroupCondition {
  final int groupId;
  final String groupName;
  final int isSatisfied;

  static const String kGroupIdName = 'groupId';
  static const String kGroupNameName = 'groupName';
  static const String kIsSatisfiedName = 'isSatisfied';

  GroupCondition({
    required this.groupId,
    required this.groupName,
    required this.isSatisfied,
  });

  Map<String, dynamic> toMap() {
    return {
      kGroupIdName: groupId,
      kGroupNameName: groupName,
      kIsSatisfiedName: isSatisfied,
    };
  }

  factory GroupCondition.fromMap(Map<String, dynamic> map) {
    return GroupCondition(
      groupId: map[kGroupIdName],
      groupName: map[kGroupNameName],
      isSatisfied: map[kIsSatisfiedName],
    );
  }
}