import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/other/action_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void showAcceptActionDialog(
  BuildContext context,
  void Function() onAccept,
  String text,
) {
  final getIt = GetIt.instance;
  final settings = Provider.of<SettingsController>(context, listen: false);
  final language = getIt<LanguageController>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: settings.outerColor,
            border: BoxBorder.all(color: settings.innerColor)
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                text, 
                style: TextStyle(
                  fontFamily: settings.fontFamily, 
                  fontSize: 20, 
                  color: settings.innerColor
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  ActionButton(
                    onTap: () => Navigator.of(context).pop(), 
                    text: language["Cancel"]
                  ),
                  ActionButton(
                    onTap: () {
                      onAccept();
                      Navigator.of(context).pop();
                    }, 
                    text: language["Accept"],
                    reversedColors: true,
                  ),
                ],
              )
            ],
          ),
        )
      );
    },
  );
}