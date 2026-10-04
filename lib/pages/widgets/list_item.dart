import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  final String _name;
  final Widget _rightWidget;

  const ListItem({
    super.key, 
    required this._name, 
    required this._rightWidget
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Container(
      padding: const EdgeInsets.only(bottom: 4, top: 4, right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: settings.innerColor), 
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget._name,
              style: TextStyle(
                fontSize: 15,
                fontFamily: settings.fontFamily,
                color: settings.innerColor
              ),
            ),
            widget._rightWidget
          ],
        ),
      ),
    );
  }
}