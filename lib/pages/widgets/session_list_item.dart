import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/models/session.dart';
import 'package:provider/provider.dart';

class SessionListItem extends StatefulWidget {
  final Session _session;
  final List<Group> _groups;
  final Widget _rightWidget;

  const SessionListItem({
    super.key, 
    required this._session, 
    required this._groups, 
    required this._rightWidget
  });

  @override
  State<SessionListItem> createState() => _SessionListItemState();
}

class _SessionListItemState extends State<SessionListItem> {
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
              widget._session.name,
              style: TextStyle(
                fontSize: 15,
                fontFamily: settings.fontFamily,
                color: settings.innerColor
              ),
            ),
            Row(
              children: [
                Wrap(
                  spacing: 8,
                  children: widget._groups.map(
                    (group) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: settings.innerColor), 
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      padding: .all(8),
                      child: Text(
                        group.name, 
                        style: TextStyle(
                          color: settings.innerColor,
                          fontFamily: settings.fontFamily
                        )
                      ),
                    )
                  ).toList()
                ),
                widget._rightWidget,
              ],
            )
          ],
        ),
      ),
    );
  }
}