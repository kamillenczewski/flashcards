import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/form_modal.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void onNewCardSubmitted(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  String word, 
  String explanation
) {
  if (word.isNotEmpty || explanation.isNotEmpty) {
    setStateMethod(() {
      getIt<CardsController>().add(word, explanation);
    });
  }
  
  Navigator.of(context).pop();
}

void showCreateCardDialog(
  BuildContext context,
  void Function(void Function()) setStateMethod,
) {
  final language = getIt<LanguageController>();

  showFormModal(
    context, 
    language["Create new card"], 
    [
      (label: language['Word'], defaultText: null),
      (label: language['Explanation'], defaultText: null),
    ], 
    (context, texts) => onNewCardSubmitted(context, setStateMethod, texts[0], texts[1])
  );
}