import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/widgets/custom_menu_button.dart';
import 'package:provider/provider.dart';

Widget createSelectOptionMenuButton<T>(
  BuildContext context,
  String currentOption,
  List<T> options,
  String Function(T) optionNameBuilder,
  void Function(T) onSelected,
) {
  final settings = context.watch<SettingsController>();

  return CustomMenuButton(
    innerWidget: Container(
      padding: .all(9),
      decoration: BoxDecoration(
        color: settings.outerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: settings.innerColor, width: 1),
      ),
      child: Row(
        spacing: 6,
        children: [
          Center(
            child: Text(
              currentOption,
              style: TextStyle(
                color: settings.innerColor,
                fontFamily: settings.fontFamily,
                fontSize: 18,  
              ),
              textAlign: .center,
            ),
          ),
          Icon(
            Icons.unfold_more,
            size: 19,
            color: settings.innerColor
          ),
        ],
      ),
    ),
    itemsData: options.map( 
      (item) => 
        (
          icon: null, 
          label: optionNameBuilder(item), 
          callback: () => onSelected(item)
        )
    ).toList()
  );
}
