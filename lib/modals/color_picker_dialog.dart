import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fproject/other/action_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void showColorPicker(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  Color defaultColor,
  void Function(String) onColorSubmitted,
) {
  final settings = Provider.of<SettingsController>(context, listen: false);
  final language = getIt<LanguageController>();
  HSVColor hsvColor = HSVColor.fromColor(defaultColor);

  final innerWidth = 300.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: settings.outerColor,
                border: BoxBorder.all(color: settings.innerColor, width: 2),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: .min,
                spacing: 12,
                children: [
                  SizedBox(
                    height: 220,
                    width: innerWidth,
                    child: ColorPickerArea(
                      hsvColor,
                      (newHsv) {
                        setState(() {
                          hsvColor = newHsv;
                        });
                      },
                      PaletteType.hsvWithHue,
                      borderRadius: 16.0,
                      borderWidth: 3.0,
                      borderColor: settings.middleColor,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    width: innerWidth,
                    child: ColorPickerSlider(
                      thumbBorderWidth: 3,
                      TrackType.hue,
                      hsvColor,
                      (newHsv) {
                        setState(() {
                          hsvColor = newHsv;
                        });
                      },
                      displayThumbColor: true,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    width: innerWidth,
                    child: ColorPickerSlider(
                      thumbBorderWidth: 3,
                      TrackType.alpha,
                      hsvColor,
                      (newHsv) {
                        setState(() {
                          hsvColor = newHsv;
                        });
                      },
                      displayThumbColor: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${hsvColor.toColor().toHexString()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: settings.fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: innerWidth,
                    child: Row(
                      mainAxisAlignment: .center,
                      mainAxisSize: .min,
                      spacing: 5,
                      children: [
                        ActionButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: language["Cancel"],
                        ),
                        ActionButton(
                          onTap: () {
                            onColorSubmitted(hsvColor.toColor().toHexString());
                            Navigator.of(context).pop();
                          },
                          text: language["Submit"],
                          reversedColors: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
