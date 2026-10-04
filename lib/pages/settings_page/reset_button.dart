import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/accept_action_dialog.dart';
import 'package:fproject/pages/settings_page/button_container.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Widget createResetButton(
  BuildContext context,
  void Function(void Function()) setState,
  String onAcceptText, 
  void Function() onReset
) {
  final language = getIt<LanguageController>();

  return GestureDetector(
    child: createButtonContainer(context, language['Reset']),
    onTap: () {
      showAcceptActionDialog(
        context, 
        () {
          setState(() {
            onReset();
          });
        }, 
        onAcceptText
      );
    },
  );
}