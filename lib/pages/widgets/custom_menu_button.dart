import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class CustomMenuButton extends StatefulWidget {
  final List<({String label, IconData? icon, void Function() callback})> _itemsData;
  final Widget? _innerWidget;

  const CustomMenuButton({
    super.key,
    this._innerWidget,
    required this._itemsData,
  });

  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: settings.middleColor,
      ),
      child: PopupMenuButton(
        position: .under,
        padding: .all(12),
        color: settings.outerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: settings.innerColor, width: 1.5),
        ),
        icon: widget._innerWidget == null ? Icon(Icons.more_horiz, color: settings.innerColor) : null,
        child: widget._innerWidget,
        itemBuilder: (context) {
          return widget._itemsData.map((data) =>
            PopupMenuItem(
              height: 0,
              padding: .only(top: 4, bottom: 4, left: 8, right: 4),
              child: Row(
                spacing: 5,
                children: [
                  data.icon == null
                  ? SizedBox()
                  : Icon(data.icon, color: settings.innerColor, size: 17),
                  Text(
                    data.label, 
                    style: TextStyle(
                      fontFamily: settings.fontFamily, 
                      color: settings.innerColor,
                      fontSize: 15
                    )
                  ),
                ],
              ),
              onTap: () => data.callback(),
            )
          ).toList();
        },
      ),
    );
  }
}

