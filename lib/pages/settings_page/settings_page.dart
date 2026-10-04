import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/settings_page/sections/appearance_and_accessibility_section.dart';
import 'package:fproject/pages/settings_page/sections/data_transfer_section.dart';
import 'package:fproject/pages/settings_page/sections/reset_options_section.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const routeName = '/SettingsPage';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Container(
      color: settings.outerColor,
      padding: .all(50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppearanceAndAccessibilitySection(),
            DataTransferSection(),
            ResetOptionsSection()
          ],
        ),
      ),
    );
  }
}