import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:provider/provider.dart';

Future<dynamic> showActionDialog(
  BuildContext context,
  String title,
  List<Widget> buttons
) async {
  final settings = Provider.of<SettingsController>(context, listen: false);

  return await showDialog(
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
                title, 
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
                children: buttons
              )
            ],
          ),
        )
      );
    },
  );
}