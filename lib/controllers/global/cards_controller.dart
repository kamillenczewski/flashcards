import 'package:flutter/material.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/services/table/cards_table_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class CardsController extends ChangeNotifier {
  final CardsTableService _cardsTableService;
  Map<int, EnglishCard> _cards = {};

  CardsController(this._cardsTableService) {
    init();
  }

  Future<void> init() async {
    for (final card in await _cardsTableService.getCards()) {
      _cards[card.id] = card;
    }
  }

  Future<void> add(String word, String explanation) async {
    final id = await _cardsTableService.addCard(word, explanation);
    _cards[id] = EnglishCard(id: id, word: word, explanation: explanation);
    notifyListeners();
  }

  Future<void> update(int id, String word, String explanation) async {
    final card = EnglishCard(id: id, word: word, explanation: explanation);
    await _cardsTableService.updateCard(card);
    _cards[id] = card;
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _cardsTableService.deleteCardAndConnections(id);
    _cards.remove(id);
    notifyListeners();
  }

  Future<void> deleteTable() async {
    await _cardsTableService.deleteTableAndConnections();
    _cards = {};
    notifyListeners();
  }

  List<EnglishCard> getAll() {
    return _cards.values.toList();
  }

  EnglishCard get(int id) {
    return _cards[id]!; 
  }

  bool existsWithWord(String word) {
    return _cards.values.where((card) => card.word == word).isNotEmpty;
  }

  int get length => _cards.length;
}