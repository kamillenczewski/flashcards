import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/color_picker_dialog.dart';
import 'package:fproject/modals/information_dialog.dart';
import 'package:fproject/models/color_theme.dart';
import 'package:fproject/other/action_button.dart';
import 'package:fproject/other/utils.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

Widget createTextInputField(
  BuildContext context,
  TextEditingController nameController,
) {
  final settings = context.watch<SettingsController>();
  final language = getIt<LanguageController>();

  return Container(
    padding: .only(right: 8, left: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      border: BoxBorder.all(width: 1, color: settings.innerColor),
    ),
    child: TextField(
      cursorColor: settings.innerColor,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: nameController,
      style: TextStyle(
        color: settings.innerColor, 
      ),
      decoration: InputDecoration(
        hintText: language['Name'],
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
  );
}

Widget createColorFieldNamesColumn(
  BuildContext context,
  List<String> fieldNames
) {
  final settings = context.watch<SettingsController>();

  return Column(
    spacing: 12,
    children: fieldNames.map(
      (name) => 
        Text(
          name.split(' ').join('\n'),
          style: TextStyle(
            fontFamily: settings.fontFamily,
            color: settings.innerColor
          ),
        )
    ).toList()
  );
}

Widget createHexInputColumn(
  BuildContext context,
  List<TextEditingController> controllers
) {
  final settings = context.watch<SettingsController>();

  return Flexible(
    child: Column(
      spacing: 12,
      children: controllers.map(
        (controller) => 
          Container(
            padding: .only(right: 8, left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: BoxBorder.all(width: 1, color: settings.innerColor),
            ),
            child: TextField(
              enableInteractiveSelection: true,
              readOnly: true,
              selectAllOnFocus: true,
              cursorColor: settings.innerColor,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: controller,
              style: TextStyle(
                color: settings.innerColor, 
              ),
              decoration: InputDecoration(
                hintText: 'Name',
                
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
          ),
      ).toList()
    ),
  );
}

Widget createColorCirclesColumn(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  List<TextEditingController> controllers
) {
  final colorCircleRadius = 15.0;

  return Column(
    spacing: 12,
    children: controllers.map(
      (controller) => 
        Padding(
        padding: const EdgeInsets.all(4),
        child: DottedBorder(
          options: CircularDottedBorderOptions(
            dashPattern: [11, 6],
            strokeWidth: 2,
            color: Colors.grey,
            padding: EdgeInsets.all(4),
          ),
          child: GestureDetector(
            onTap: () {
              showColorPicker(
                context, setStateMethod, hexToColor(controller.text),
                (pickedColor) {
                  setStateMethod(() {
                    controller.text = pickedColor;
                  }); 
                }
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: .circular(colorCircleRadius),
                color: hexToColor(controller.text)
              ),
              child: SizedBox(
                width: 2*colorCircleRadius,
                height: 2*colorCircleRadius,
              ),
            ),
          ),
        ),
      )
    ).toList()
  );
}

Widget createColorInputFields(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  List<String> fieldNames,
  List<TextEditingController> controllers
) {
  return Row(
    spacing: 8,
    children: [
      createColorFieldNamesColumn(context, fieldNames),
      createHexInputColumn(context, controllers),
      createColorCirclesColumn(context, setStateMethod, controllers)
    ],
  );
}

void createThemeDialog(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  void Function(BuildContext, String, String, String) onSubmitted,
  {
    void Function(BuildContext)? onDelete,
    String? defaultName,
    String? defaultInnerColor,
    String? defaultOuterColor,
  }
) {
  final settings = Provider.of<SettingsController>(context, listen: false);
  final language = getIt<LanguageController>();

  final nameController = TextEditingController(text: defaultName);
  final innerColorController = TextEditingController(text: defaultInnerColor ?? Colors.white.toHexString());
  final outerColorController = TextEditingController(text: defaultOuterColor ?? Colors.black.toHexString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
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
                  children: [
                    Flexible(
                      child: Text(
                        language['Create new theme'], 
                        style: TextStyle(
                          fontFamily: settings.fontFamily, 
                          fontSize: 25, 
                          color: settings.innerColor
                        ),
                      ),
                    ),
                    createTextInputField(context, nameController),
                    createColorInputFields(
                      context, setModalState, 
                      [language['Inner Color'], language['Outer Color']],
                      [innerColorController, outerColorController]
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 5,
                      children: [
                        ActionButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: language["Cancel"],
                        ),

                        onDelete == null
                        ? SizedBox.shrink()
                        : ActionButton(
                            onTap: () {
                              Navigator.of(context).pop();  
                              onDelete(context);
                            }, 
                            text: language["Delete"],
                            enabled: !ColorTheme.pernamentColorThemeNames.contains(nameController.text),
                          ),

                        ActionButton(
                          onTap: () {
                            if (nameController.text.isEmpty) {
                              showInformationDialog(context, language['Name cannot be empty!']);
                            }
                            else {
                              onSubmitted(context, nameController.text, innerColorController.text, outerColorController.text);
                              Navigator.of(context).pop();
                            }
                          },
                          onDisenableTap: () => setModalState(() {}),
                          text: language["Submit"],
                          enabled: !ColorTheme.pernamentColorThemeNames.contains(nameController.text),
                          reversedColors: true,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          );
        }
      );
    },
  );
}