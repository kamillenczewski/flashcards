import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class ActionButton extends StatefulWidget {
  final void Function() _onTap;
  final void Function()? _onDisenableTap;
  final String _text;
  final bool _reversedColors;
  final bool _enabled;

  const ActionButton({
    super.key,
    required this._onTap,
    required this._text,
    this._reversedColors = false,
    this._enabled = true,
    this._onDisenableTap,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Color getTextColor(SettingsController settings) {
    if (widget._reversedColors) {
      return settings.outerColor;
    }
    else {
      return widget._enabled ? settings.innerColor : settings.middleColor;
    }
  }

  Color getContainerColor(SettingsController settings) {
    if (widget._reversedColors) {
      if (widget._enabled) {
        return settings.innerColor;
      }
      else {
        return settings.middleColor;
      }
    }
    else {
      return settings.outerColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return GestureDetector(
      onTap: () {
        if (widget._enabled) {
          widget._onTap();;
        }
        else if (widget._onDisenableTap != null) {
          widget._onDisenableTap!();
        }
      },
      child: Container(
        padding: EdgeInsetsGeometry.all(8),
        decoration: BoxDecoration(
          color: getContainerColor(settings), 
          border: Border.all(
            width: 1, 
            color: widget._enabled ? settings.innerColor : settings.middleColor
          ), 
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Text(
          widget._text, 
          style: TextStyle(
            fontFamily: settings.fontFamily, 
            color: getTextColor(settings)
          )
        )
      ),
    );
  }
}

