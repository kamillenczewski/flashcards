import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/other/action_button.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void showChooseGroupToSessionDialog(
  BuildContext context,
  List<Group> defaultGroups,
  void Function(List<Group>) onGroupsSubmitted,
) {
  final settings = Provider.of<SettingsController>(context, listen: false);
  final groupsController = getIt<GroupsController>();
  final language = getIt<LanguageController>();
  
  final groupsData = groupsController
    .getAll()
    .map((group) => (group: group, isInSession: defaultGroups.contains(group)))
    .toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: settings.outerColor,
                  border: BoxBorder.all(color: settings.innerColor)
                ),
                padding: const .all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemCount: groupsData.length,
                        itemBuilder: (context, index) {
                          final group = groupsData[index].group;
                          final isInSession = groupsData[index].isInSession;
            
                          return Container(
                            padding: const .all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: settings.innerColor), 
                                borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                              padding: const .only(right: 8, left: 8, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    group.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: settings.fontFamily,
                                      color: settings.innerColor
                                    ),
                                  ),
                                  Checkbox(
                                    side: BorderSide(color: settings.innerColor),
                                    activeColor: settings.innerColor,
                                    checkColor: settings.outerColor,
                                    value: isInSession, 
                                    onChanged: (value) { 
                                      setState(() {
                                        groupsData[index] = (group: group, isInSession: value!);
                                      });                
                                    }
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ActionButton(
                      onTap: () {
                        onGroupsSubmitted(groupsData.where((data) => data.isInSession).map((data) => data.group).toList());
                        Navigator.of(context).pop();
                      }, 
                      text: language['Accept'],
                      reversedColors: true,
                    )
                  ],
                )
              ),
            );
          },
        )
      );
    },
  );
}