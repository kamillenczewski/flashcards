import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/form_modal.dart';
import 'package:fproject/models/english_card.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void onCardEdited(
  BuildContext context,
  void Function(void Function()) setStateMethod,
  int cardId,
  String newWord,
  String newExplanation,
) {
  if (newWord.isNotEmpty || newExplanation.isNotEmpty) {
    setStateMethod(() {
      getIt<CardsController>().update(cardId, newWord, newExplanation);
    });
  }
  
  Navigator.of(context).pop();
}
void showEditCardDialog(
  BuildContext context, 
  void Function(void Function()) setStateMethod,
  EnglishCard card,
) {
  final language = getIt<LanguageController>();

  showFormModal(
    context, 
    language["Edit the card"], 
    [
      (label: language['Word'], defaultText: card.word),
      (label: language['Explanation'], defaultText: card.explanation),
    ], 
    (context, texts) => onCardEdited(context, setStateMethod, card.id, texts[0], texts[1])
  );
}