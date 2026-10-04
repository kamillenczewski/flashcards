import 'dart:ui';

import 'package:cli_table/cli_table.dart';
import 'dart:math';

void printTable(List<Map<String, dynamic>> queryResults, int? limit) {
  if (queryResults.isEmpty) return;

  limit ??= 10;

  final headers = queryResults.first.keys.toList();

  final table = Table(
    header: headers,
    style: TableStyle(compact: true),
  );

  for (var i = 0; i < min(limit, queryResults.length); i++) {
    table.add(queryResults[i].values.toList());
  }

  print(table.toString());
}

String getTitle(String text) {
  return text.replaceFirst(text[0], text[0].toUpperCase());
}

Color hexToColor(String hexString) {
  final buffer = StringBuffer();

  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');

  buffer.write(hexString.replaceFirst('#', ''));

  return Color(int.parse(buffer.toString(), radix: 16));
}

String getColorInBetween(String startColor, String endColor, {double coeff = 0.5}) {
  final rI = int.parse(startColor.substring(2, 4), radix: 16);
  final gI = int.parse(startColor.substring(4, 6), radix: 16);
  final bI = int.parse(startColor.substring(6, 8), radix: 16);

  final rO = int.parse(endColor.substring(2, 4), radix: 16);
  final gO = int.parse(endColor.substring(4, 6), radix: 16);
  final bO = int.parse(endColor.substring(6, 8), radix: 16);

  final r = ((rI + rO) * coeff).toInt().toRadixString(16);
  final g = ((gI + gO) * coeff).toInt().toRadixString(16);
  final b = ((bI + bO) * coeff).toInt().toRadixString(16);

  return 'ff$r$g$b';
}