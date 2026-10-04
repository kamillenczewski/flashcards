import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/form_modal.dart';
import 'package:fproject/models/group.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void onGroupEdited(
  BuildContext context, 
  void Function(void Function()) setStateMethod,
  Group group,
  String newName
) {
  if (group.name.isNotEmpty) {
    getIt<GroupsController>().update(group.id, newName);
    setStateMethod(() {});
  }
  
  Navigator.of(context).pop();
}

void showEditGroupDialog(
  BuildContext context, 
  void Function(void Function()) setStateMethod,
  Group group,
) {
  final language = getIt<LanguageController>();

  showFormModal(
    context, 
    language["Edit the group"], 
    [(label: language['Name'], defaultText: group.name)], 
    (context, texts) => onGroupEdited(context, setStateMethod, group, texts[0])
  );
}