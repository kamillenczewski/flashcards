import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/widgets/card_list_item.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class AddCardsToGroupPage extends StatefulWidget {
  final Group group;
  
  const AddCardsToGroupPage(this.group, {super.key});

  @override
  State<AddCardsToGroupPage> createState() => _AddCardsToGroupPageState();
}

class _AddCardsToGroupPageState extends State<AddCardsToGroupPage> {
  final _groupLinksTableService = getIt<GroupLinksTableService>();
  final _language = getIt<LanguageController>();

  @override
  Widget build(BuildContext context) {  
    final settings = context.watch<SettingsController>();

    return Container(
      decoration: BoxDecoration(
        color: settings.outerColor
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_language['Add cards to the group']}: ${widget.group.name}",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    fontFamily: settings.fontFamily,
                    color: settings.innerColor
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, 
                  icon: Icon(Icons.arrow_back, color: settings.innerColor)
                ),
              ],
            ),
            SizedBox(height: 4),
            FutureBuilder(
              future: _groupLinksTableService.getCardConditionsForGroup(widget.group.id), 
              builder: (context, snapshot) {
                final cardConditions = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: cardConditions.length,
                    itemBuilder: (context, index) {
                      final card = cardConditions[index].card;
                      final isSatisfied = cardConditions[index].isSatisfied;

                      return CardListItem(
                        card: card, 
                        rightWidget: Checkbox(
                          side: BorderSide(color: settings.innerColor),
                          activeColor: settings.innerColor,
                          checkColor: settings.outerColor,
                          value: isSatisfied == 1, 
                          onChanged: (value) {
                            final isCardInGroup = value ?? false;
                                    
                            setState(() {
                              if (isCardInGroup) {
                                _groupLinksTableService.addLink(widget.group.id, card.id);
                              } 
                              else {
                                _groupLinksTableService.deleteLink(widget.group.id, card.id);
                              }
                            });
                          }
                        )
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}