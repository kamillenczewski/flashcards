import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/modals/accept_action_dialog.dart';
import 'package:fproject/pages/settings_page/button_container.dart';
import 'package:fproject/pages/settings_page/section.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class ResetOptionsSection extends StatefulWidget {
  const ResetOptionsSection({super.key});

  @override
  State<ResetOptionsSection> createState() => _ResetOptionsSection();
}

class _ResetOptionsSection extends State<ResetOptionsSection> {
  final _language = getIt<LanguageController>();
  final _cardsController = getIt<CardsController>();
 
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return createSection(
      context, 
      _language['Reset Option'], 
      [
        (
          _language['Cards'], 
          [GestureDetector(
            child: createButtonContainer(context, _language['Reset']),
            onTap: () async {
              showAcceptActionDialog(
                context, 
                () {
                  _cardsController.deleteTable();
                  setState(() {});
                }, 
                _language['Are you sure you want to reset cards?']
              );
            },
          )]
        ),
        (
          _language['Options'], 
          [GestureDetector(
            child: createButtonContainer(context, _language['Reset']),
            onTap: () {
              settings.resetColorThemeId();
              settings.resetLanguage();
              settings.resetFontFamily();
            },
          )]
        ),
      ],
    );
  }
}