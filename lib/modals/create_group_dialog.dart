import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/form_modal.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void onNewGroupSubmitted(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  String name,
) {
  if (name.isNotEmpty) {
    setStateMethod(() {
      getIt<GroupsController>().add(name);
    });
  }
  
  Navigator.of(context).pop();
}

void showCreateGroupDialog(
  BuildContext context,
  void Function(void Function()) setStateMethod,
) {
  final language = getIt<LanguageController>();
  
  showFormModal(
    context, 
    language["Create a new group"], 
    [(label: language['Name'], defaultText: null)], 
    (context, texts) => onNewGroupSubmitted(context, setStateMethod, texts[0])
  );
}