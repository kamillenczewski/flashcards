import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/widgets/card_list_item.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class CardsInGroupPage extends StatefulWidget {
  final Group group;
  
  const CardsInGroupPage(this.group, {super.key});

  @override
  State<CardsInGroupPage> createState() => _CardsInGroupPageState();
}

class _CardsInGroupPageState extends State<CardsInGroupPage> {
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
          spacing: 4,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_language['Cards in group']}: ${widget.group.name}",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    fontFamily: settings.fontFamily,
                    color: settings.innerColor
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  icon: Icon(Icons.arrow_back, color: settings.innerColor)
                ),
              ],
            ),
            FutureBuilder(
              future: _groupLinksTableService.getCardsFromGroup(widget.group.id), 
              builder: (context, snapshot) {
                final cards = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return CardListItem(
                        card: cards[index], 
                        rightWidget: IconButton(
                          onPressed: () async {
                            await _groupLinksTableService.deleteLink(widget.group.id, cards[index].id);
                            setState(() {});
                          }, 
                          icon: Icon(Icons.delete, color: settings.innerColor)
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

