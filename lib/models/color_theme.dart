import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fproject/other/utils.dart';

class ColorTheme {
  final int id;
  final String name;
  final String innerColor;
  final String outerColor;
  final String middleColor;

  static const String kTable = 'ColorThemes';
  static const String kId = 'id';
  static const String kName = 'name';
  static const String kInnerColor = 'innerColor'; 
  static const String kOuterColor = 'outerColor'; 
  static const String kMiddleColor = 'middleColor'; 

  static final kDarkTheme = ColorTheme(
    id: 1,
    name: 'dark',
    innerColor: Colors.white.toHexString(),
    outerColor: Colors.black.toHexString(),
    middleColor: getColorInBetween(Colors.white.toHexString(), Colors.black.toHexString()),
  );

  static final kLightTheme = ColorTheme(
    id: 2,
    name: 'light',
    innerColor: Colors.black.toHexString(),
    outerColor: Colors.white.toHexString(),
    middleColor: getColorInBetween(Colors.white.toHexString(), Colors.black.toHexString()),
  );

  static final pernamentColorThemeNames = [kDarkTheme.name, kLightTheme.name];

  ColorTheme({
    required this.id,
    required this.name,
    required this.innerColor,
    required this.outerColor,
    required this.middleColor,
  });

  Map<String, dynamic> toMap() {
    return {
      kId: id,
      kName: name,
      kInnerColor: innerColor,
      kOuterColor: outerColor,
      kMiddleColor: middleColor,
    };
  }

  factory ColorTheme.fromMap(Map<String, dynamic> map) {
    return ColorTheme(
      id: map[kId],
      name: map[kName],
      innerColor: map[kInnerColor],
      outerColor: map[kOuterColor],
      middleColor: map[kMiddleColor],
    );
  }
}