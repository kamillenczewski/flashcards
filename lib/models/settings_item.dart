class SettingsItem {
  final int id;
  final String name;
  final String value;

  static const String kTable = 'Settings';
  static const String kId = 'id';
  static const String kName = 'name';
  static const String kValue = 'value';

  static final fontFamilyItem = SettingsItem(
    id: 1,
    name: 'fontFamily',
    value: 'Lexend'
  );

  static final colorThemeIdItem = SettingsItem(
    id: 2,
    name: 'colorThemeId',
    value: '1',
  );

  static final languageItem = SettingsItem(
    id: 3,
    name: 'language',
    value: 'english',
  );

  SettingsItem({
    required this.id,
    required this.name,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kName: name,
      kValue: value
    };
  }

  factory SettingsItem.fromMap(Map<String, dynamic> map) {
    return SettingsItem(
      id: map[kId],
      name: map[kName],
      value: map[kValue],
    );
  }
}