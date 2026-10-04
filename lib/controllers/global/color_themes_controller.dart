import 'package:flutter/material.dart';
import 'package:fproject/models/color_theme.dart';
import 'package:fproject/other/utils.dart';
import 'package:fproject/services/table/color_theme_table_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ColorThemesController extends ChangeNotifier {
  final _colorThemeTableService = getIt<ColorThemeTableService>();

  final _colorThemes = {
    ColorTheme.kLightTheme.id: ColorTheme.kLightTheme,
    ColorTheme.kDarkTheme.id: ColorTheme.kDarkTheme,
  };

  ColorThemesController() {
    init();
  }

  Future<void> init() async {
    final data = await _colorThemeTableService.getAll();
    
    for (final item in data) {
      _colorThemes[item.id] = item;
    }
  }

  Future<void> add(String name, String inner, String outer) async {
    final middleColor = getColorInBetween(inner, outer);
    int id = await _colorThemeTableService.add(name, inner, outer, middleColor);
    _colorThemes[id] = ColorTheme(id: id, name: name, innerColor: inner, outerColor: outer, middleColor: middleColor);
    notifyListeners();
  }

  Future<void> update(int id, String name, String inner, String outer) async {
    final middleColor = getColorInBetween(inner, outer);
    _colorThemes[id] = ColorTheme(id: id, name: name, innerColor: inner, outerColor: outer, middleColor: middleColor);
    await _colorThemeTableService.update(id, name, inner, outer, middleColor);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    _colorThemes.remove(id);
    await _colorThemeTableService.delete(id);
    notifyListeners();
  }

  List<ColorTheme> getAll() {
    return _colorThemes.values.toList();
  }

  ColorTheme get(int id) {
    return _colorThemes[id]!;
  }

  bool nameExists(String name) {
    return _colorThemes.values.map((e) => e.name).contains(name);
  }
}