import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:provider/provider.dart';

Widget createIconContainer(BuildContext context, IconData icon) {
  final settings = context.watch<SettingsController>();

  return Container(
    padding: .all(5),
    decoration: BoxDecoration(
      borderRadius: .circular(10),
      color: settings.outerColor,
      border: .all(color: settings.innerColor)
    ),
    child: Icon(icon, color: settings.innerColor, size: 31)
  );
}