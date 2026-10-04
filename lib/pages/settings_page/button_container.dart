import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:provider/provider.dart';

Widget createButtonContainer(BuildContext context, String text) {
  final settings = context.watch<SettingsController>();

  return Container(
    padding: .all(9),
    decoration: BoxDecoration(
      color: settings.outerColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: settings.innerColor, width: 1),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: settings.innerColor,
          fontFamily: settings.fontFamily,
          fontSize: 18,  
        ),
        textAlign: .center,
      ),
    ),
  );
}