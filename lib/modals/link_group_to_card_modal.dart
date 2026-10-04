import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void showLinkGroupToCardModal(
  BuildContext context,  
  void Function(void Function()) setStateMethod,
  int cardId
) {
  final getIt = GetIt.instance;
  final groupLinksTableService = getIt<GroupLinksTableService>();
  final settings = Provider.of<SettingsController>(context, listen: false);
  final language = getIt<LanguageController>();

  showModalBottomSheet(
    context: context,
    constraints: const BoxConstraints(maxWidth: 500), 
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: settings.outerColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: settings.innerColor)
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language['Add card to the group'],
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          fontFamily: settings.fontFamily,
                          color: settings.innerColor
                        ),
                      ),
                      Divider(color: settings.innerColor),
                      Flexible(
                        child: FutureBuilder(
                          future: groupLinksTableService.getGroupConditionsForCard(cardId),
                          builder: (context, snapshot) {
                            final isCardInGroupTable = snapshot.data ?? [];

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: isCardInGroupTable.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isCardInGroupTable[index].groupName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: settings.fontFamily,
                                          color: settings.innerColor
                                        ),
                                      ),
                                      Checkbox(
                                        side: BorderSide(color: settings.innerColor),
                                        activeColor: settings.innerColor,
                                        checkColor: settings.outerColor,
                                        value: isCardInGroupTable[index].isSatisfied == 1, 
                                        onChanged: (bool? value) {
                                          var isInSession = value ?? false;
                                          
                                          setStateMethod(() {
                                            setModalState(() {
                                              if (isInSession) {
                                                groupLinksTableService.addLink(isCardInGroupTable[index].groupId, cardId);
                                              } 
                                              else {
                                                groupLinksTableService.deleteLink(isCardInGroupTable[index].groupId, cardId);
                                              }
                                            });
                                          });
                                        }
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}