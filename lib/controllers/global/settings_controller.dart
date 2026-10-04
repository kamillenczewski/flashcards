import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/color_themes_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/models/settings_item.dart';
import 'package:fproject/other/utils.dart';
import 'package:fproject/services/table/settings_table_service.dart';

class SettingsController extends ChangeNotifier {
  final SettingsTableService _settingsTableService;
  final ColorThemesController _colorThemesController;
  final LanguageController _languageController;

  final _namesAndValues = {
    SettingsItem.fontFamilyItem.name: SettingsItem.fontFamilyItem.value,
    SettingsItem.colorThemeIdItem.name: SettingsItem.colorThemeIdItem.value,
    SettingsItem.languageItem.name: SettingsItem.languageItem.value,
  };

  SettingsController(
    this._settingsTableService, 
    this._colorThemesController,
    this._languageController,
  ) {
    init();
    _colorThemesController.addListener(_onColorThemeControllerChanged);
  }

  Future<void> init() async {
    for (final name in _namesAndValues.keys) {
      _namesAndValues[name] = await _settingsTableService.getValue(name);
    }
  }

  Future<void> updateOption(String name, String value) async {
    _namesAndValues[name] = value;
    await _settingsTableService.setValue(name, value);
    notifyListeners();
  }

  String get fontFamily => _namesAndValues[SettingsItem.fontFamilyItem.name]!;
  int get colorThemeId => int.parse(_namesAndValues[SettingsItem.colorThemeIdItem.name]!);
  String get language => _namesAndValues[SettingsItem.languageItem.name]!;

  set fontFamily(String value) => updateOption(SettingsItem.fontFamilyItem.name, value);
  set colorThemeId(int value) => updateOption(SettingsItem.colorThemeIdItem.name, value.toString());
  set language(String value) {
    updateOption(SettingsItem.languageItem.name, value);
    _languageController.updateExpressions(language);
  }

  void resetFontFamily() => fontFamily = SettingsItem.fontFamilyItem.value;
  void resetColorThemeId() => colorThemeId = int.parse(SettingsItem.colorThemeIdItem.value);
  void resetLanguage() => language = SettingsItem.languageItem.value;


  String get colorThemeName => _colorThemesController.get(colorThemeId).name;
  Color get innerColor => hexToColor(_colorThemesController.get(colorThemeId).innerColor);
  Color get outerColor => hexToColor(_colorThemesController.get(colorThemeId).outerColor);
  Color get middleColor => hexToColor(_colorThemesController.get(colorThemeId).middleColor);

  void _onColorThemeControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _colorThemesController.removeListener(_onColorThemeControllerChanged);
    super.dispose();
  }
}