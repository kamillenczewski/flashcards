import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/color_themes_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/modals/accept_action_dialog.dart';
import 'package:fproject/modals/create_theme_dialog.dart';
import 'package:fproject/modals/information_dialog.dart';
import 'package:fproject/models/color_theme.dart';
import 'package:fproject/models/settings_item.dart';
import 'package:fproject/pages/widgets/custom_menu_button.dart';
import 'package:fproject/other/utils.dart';
import 'package:fproject/pages/settings_page/icon_container.dart';
import 'package:fproject/pages/settings_page/reset_button.dart';
import 'package:fproject/pages/settings_page/section.dart';
import 'package:fproject/pages/settings_page/select_option_menu_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:system_fonts/system_fonts.dart';

final getIt = GetIt.instance;


Widget createColorThemeButton(
  BuildContext context,
  void Function(void Function()) setState,
) {
  final options = getIt<ColorThemesController>().getAll().toList();
  final settings = context.watch<SettingsController>();

  return createSelectOptionMenuButton(
    context,
    getTitle(settings.colorThemeName),
    options,
    (option) => getTitle(option.name),
    (option) async {
      setState(() {
        settings.updateOption(SettingsItem.colorThemeIdItem.name, option.id.toString());
      });
    }
  );
}

Widget createAddThemeButton(
  BuildContext context,
  void Function(void Function()) setState,
) {
  final colorThemesController = getIt<ColorThemesController>();

  return GestureDetector(
    child: createIconContainer(context, Icons.add),
    onTap: () {
      createThemeDialog(
        context, setState, 
        (c, name, inner, outer) {
          name = name.toLowerCase();
          
          if (colorThemesController.nameExists(name)) {
            showInformationDialog(
              context,
              "Color Theme with name: '$name' already exists!"
            );
          }
          else {
            colorThemesController.add(name, inner, outer);
          }
        }
      );
    },
  );
}

Widget createEditThemeButton(
  BuildContext context,
  void Function(void Function()) setState,
) {
  final language = getIt<LanguageController>();
  final colorThemesController = getIt<ColorThemesController>();
  
  return CustomMenuButton(
    innerWidget: createIconContainer(context, Icons.construction),
    itemsData: colorThemesController.getAll().map( 
      (item) => 
        (
          icon: null, 
          label: getTitle(item.name), 
          callback: () {
            setState(() {
              createThemeDialog(context, setState, 
                (_, name, inner, outer) {
                  colorThemesController.update(item.id, name, inner, outer);
                },
                onDelete: (context) {
                  showAcceptActionDialog(
                    context, 
                    () {
                      setState(() {
                        colorThemesController.delete(item.id);
                      });
                    }, 
                    "${language['Are you sure you want to delete theme with name']}: ${item.name}"
                  );
                },
                defaultName: item.name,
                defaultInnerColor: item.innerColor,
                defaultOuterColor: item.outerColor,
              );
            });
          }
        )
    ).toList()
  );
}

Widget createFontFamiliyButton(
  BuildContext context,
  void Function(void Function()) setState,
) {
  final settings = context.watch<SettingsController>();
  final fontFamilies = Set
    .from(
      SystemFonts()
        .getFontList()
        .map((x) => getTitle(x.split('-')[0]))
    )
    .whereType<String>()
    .toList();

  return createSelectOptionMenuButton(
    context,
    getTitle(settings.fontFamily),
    fontFamilies,
    (option) => getTitle(option),
    (option) async {
      await SystemFonts().loadFont(option);
      setState(() {
        settings.updateOption(SettingsItem.fontFamilyItem.name, option);
      });
    }
  );
}

Widget createLanguageButton(
  BuildContext context,
  void Function(void Function()) setState,
) {
  final settings = context.watch<SettingsController>();
  final language = getIt<LanguageController>();

  return createSelectOptionMenuButton(
    context,
    getTitle(settings.language),
    language.languages,
    (option) => getTitle(option),
    (option) {
      setState(() {
        settings.language = option;
      });       
    }
  );
}

class AppearanceAndAccessibilitySection extends StatefulWidget {
  const AppearanceAndAccessibilitySection({super.key});

  @override
  State<AppearanceAndAccessibilitySection> createState() => _AppearanceAndAccessibilitySectionState();
}

class _AppearanceAndAccessibilitySectionState extends State<AppearanceAndAccessibilitySection> {
  final language = getIt<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return createSection(
      context, 
      language['Appearance & Accessibility'], 
      [
        (
          language['Color Theme'], 
          [
            settings.colorThemeName == ColorTheme.kDarkTheme.name
            ? SizedBox.shrink()
            : createResetButton(
                context, setState,
                language['Are you sure you want to reset color theme?'],
                () => settings.resetColorThemeId()
              ),
            createAddThemeButton(context, setState),
            createEditThemeButton(context, setState),
            createColorThemeButton(context, setState)
          ]
        ),
        (
          language['Font Family'], 
          [
            settings.fontFamily == SettingsItem.fontFamilyItem.value
            ? SizedBox.shrink()
            : createResetButton(
                context, setState,
                language['Are you sure you want to reset Font Family?'],
                () => settings.resetFontFamily()
              ),
            createFontFamiliyButton(context, setState)
          ]
        ),
        (
          language['Language'], 
          [
            settings.language == SettingsItem.languageItem.value
            ? SizedBox.shrink()
            : createResetButton(
                context, setState,
                language['Are you sure you want to reset Language?'],
                () => settings.resetLanguage()
              ),
            createLanguageButton(context, setState)
          ]
        ),
      ],
    );
  }
}