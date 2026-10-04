import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/other/action_button.dart';
import 'package:provider/provider.dart';

void showInformationDialog(
  BuildContext context,
  String text,
) {
  final settings = Provider.of<SettingsController>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          width: 300,
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
                textAlign: .center,
                style: TextStyle(
                  fontFamily: settings.fontFamily, 
                  fontSize: 20, 
                  color: settings.innerColor,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  ActionButton(
                    onTap: () => Navigator.of(context).pop(),
                    text: "Ok",
                    reversedColors: true,
                  )
                ],
              )
            ],
          ),
        )
      );
    },
  );
}