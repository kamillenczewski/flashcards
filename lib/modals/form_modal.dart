import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/other/action_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void showFormModal(
  BuildContext context,
  String title,
  List<({String label, String? defaultText})> labelsAndDefaultTexts,
  void Function(BuildContext, List<String>) onSubmitted,
) {
  final textControllers = labelsAndDefaultTexts.map((e) => TextEditingController(text: e.defaultText)).toList();
  final settings = Provider.of<SettingsController>(context, listen: false);
  final language = getIt<LanguageController>();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: 300,
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
              children: <Widget>[
                Flexible(
                  child: Text(
                    title, 
                    style: TextStyle(
                      fontFamily: settings.fontFamily, 
                      fontSize: 25, 
                      color: settings.innerColor
                    ),
                  ),
                )
              ] + 
              List<Container>.generate(
                labelsAndDefaultTexts.length, (index) =>
                  Container(
                    padding: .only(right: 8, left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: BoxBorder.all(width: 1, color: settings.innerColor),
                    ),
                    child: TextField(
                      cursorColor: settings.innerColor,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: textControllers[index],
                      style: TextStyle(
                        color: settings.innerColor, 
                      ),
                      decoration: InputDecoration(
                        hintText: labelsAndDefaultTexts[index].label,
                        hintStyle: TextStyle(
                          fontFamily: settings.fontFamily, 
                          color: settings.middleColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        floatingLabelBehavior: .never,
                        floatingLabelStyle: TextStyle(fontSize: 0)
                      ),
                    ),
                  )
              ) + [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    ActionButton(
                      onTap: () => Navigator.of(context).pop(), 
                      text: language["Cancel"]
                    ),
                    ActionButton(
                      onTap: () => onSubmitted(context, textControllers.map((e) => e.text).toList()), 
                      text: language["Submit"],
                      reversedColors: true,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      );
    },
  );
}