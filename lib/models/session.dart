class Session {
  final int id;
  final String name;
  final int? currentCardId;

  static const String kTable = 'Sessions';
  static const String kId = 'id';
  static const String kName = 'name';
  static const String kCurrentCardId = 'currentCardId';

  Session({
    required this.id,
    required this.name,
    required this.currentCardId,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kName: name,
      kCurrentCardId: currentCardId,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map[kId],
      name: map[kName],
      currentCardId: map[kCurrentCardId],
    );
  }
}