import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/widgets/group_list_item.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class GroupsForCardPage extends StatefulWidget {
  final EnglishCard card;
  
  const GroupsForCardPage(this.card, {super.key});

  @override
  State<GroupsForCardPage> createState() => _GroupsForCardPageState();
}

class _GroupsForCardPageState extends State<GroupsForCardPage> {
  final _groupLinksTableService = getIt<GroupLinksTableService>();
  final _language = getIt<LanguageController>();
  
  @override
  Widget build(BuildContext context) {  
    final settings = context.watch<SettingsController>();

    return Container(
      color: settings.outerColor,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_language['Groups for card']}: ${widget.card.word}",
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
              future: _groupLinksTableService.getGroupsFromCard(widget.card.id), 
              builder: (context, snapshot) {
                final groups = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return GroupListItem(
                        group: groups[index], 
                        rightWidget: IconButton(
                          onPressed: () async {
                            await _groupLinksTableService.deleteLink(groups[index].id, widget.card.id);
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

