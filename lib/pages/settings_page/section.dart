import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:provider/provider.dart';

Widget createOptionWidget(
  BuildContext context, 
  String optionName,
  List<Widget> innerWidgets
) {
  final settings = context.watch<SettingsController>();

  return Padding(
    padding: .all(20),
    child: Row(
      mainAxisSize: .max,
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          optionName,
          style: TextStyle(
            fontSize: 20,
            color: settings.innerColor,
            fontFamily: settings.fontFamily,
            fontWeight: .normal
          ),
        ),
        Row(
          spacing: 6,
          children: innerWidgets,
        )
      ],
    ),
  );
}  

Widget createSection(
  BuildContext context,
  String title, 
  List<(String, List<Widget>)> optionNamesAndWidgets
) {
  final settings = context.watch<SettingsController>();

  return Column(
    children: [
      Padding(
        padding: .only(bottom: 12, left: 8, top: 25),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: settings.fontFamily,
            color: settings.innerColor,
            fontSize: 22,
            fontWeight: .bold
          ),
          textAlign: .left,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: settings.middleColor,
          borderRadius: .all(Radius.circular(10))
        ),
        child: Column(
          mainAxisSize: .min,
          children: 
            optionNamesAndWidgets
              .sublist(0, optionNamesAndWidgets.length - 1)
              .map<Widget>(
                (optionNameAndWidget) => 
                  Column(
                    children: [
                      createOptionWidget(context, optionNameAndWidget.$1, optionNameAndWidget.$2), 
                      Divider()
                    ]
                  )
              )
              .toList()
            + [createOptionWidget(context, optionNamesAndWidgets[optionNamesAndWidgets.length - 1].$1, optionNamesAndWidgets[optionNamesAndWidgets.length - 1].$2)]
        ),
      ),
    ],
  );
}
