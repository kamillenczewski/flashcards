import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/other/utils.dart';
import 'package:provider/provider.dart';

class CardListItem extends StatefulWidget {
  final EnglishCard _card;
  final Widget _rightWidget;

  const CardListItem({
    super.key, 
    required this._card,
    required this._rightWidget
  });

  @override
  State<CardListItem> createState() => _CardListItemState();
}

class _CardListItemState extends State<CardListItem> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Container(
      padding: const .only(bottom: 4, top: 4, right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: settings.innerColor), 
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const .all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: .all(width: 1, color: settings.innerColor),
                      borderRadius: .circular(10),
                      color: settings.middleColor
                    ),
                    padding: .all(8),
                    child: Text(
                      getTitle(widget._card.word),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: settings.fontFamily,
                        color: settings.innerColor
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(                           
                      getTitle(widget._card.explanation),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: settings.fontFamily,
                        color: settings.innerColor
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget._rightWidget
          ],
        ),
      ),
    );
  }
}