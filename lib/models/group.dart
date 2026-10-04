class Group {
  final int id;
  final String name;

  static const String kTable = 'Groups';
  static const String kId = 'id';
  static const String kName = 'name';

  static final kAllGroup = Group(
    id: 1,
    name: 'All',
  );

  static final kFavoriteGroup = Group(
    id: 2,
    name: 'Favorite',
  );

  static final List<String> permanentGroupNames = [kFavoriteGroup.name, kAllGroup.name];

  Group({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kName: name,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map[kId],
      name: map[kName],
    );
  }
}