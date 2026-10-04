import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fproject/other/utils.dart';
import 'package:path/path.dart';

class LanguageController extends ChangeNotifier {
  static const languagesFolder = 'languages';
  static const suffix = '.json';
  static const defaultLanguage = 'english';

  Map<String, dynamic> _expressions = {};
  List<String> _languages = [defaultLanguage];

  LanguageController() {
    _loadLanguages();
  }

  void _loadLanguages() async {
    final dir = Directory(languagesFolder);
    final fileEntities = await dir.list().toList();

    final names = fileEntities
      .whereType<File>()
      .map(
        (e) => getTitle(
          basename(e.path)
            .replaceAll(suffix, '')
        )
      )
      .toList();

    _languages = [defaultLanguage, ...names];
  }

  void updateExpressions(String newLanguage) {
    final path = join(languagesFolder, newLanguage + suffix);
    final file = File(path);

    if (newLanguage == defaultLanguage) {
      _expressions = {};
    }

    if (!file.existsSync()) return;

    final content = file.readAsStringSync();
    _expressions = jsonDecode(content);
  }

  List<String> get languages => _languages;
  String operator [](String englishExpression) => _expressions[englishExpression] ?? englishExpression;
}