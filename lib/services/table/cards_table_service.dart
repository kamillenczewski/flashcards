import 'package:fproject/models/english_card.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/services/table/database_service.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:fproject/services/table/notes_table_service.dart';

class CardsTableService {
  final DatabaseService _dbService;
  final GroupLinksTableService _groupLinksTableService;
  final NotesTableService _notesTableService;

  CardsTableService(
    this._dbService,
    this._groupLinksTableService,
    this._notesTableService,
  );

  Future<int> addCard(String word, String explanation) async {
    final db = await _dbService.database;

    final id = await db.insert(
      EnglishCard.kTable, 
      {
        EnglishCard.kWord: word,
        EnglishCard.kExplanation: explanation,
      }
    );

    await _groupLinksTableService.addLink(Group.kAllGroup.id, id);

    return id;
  }

  Future<List<EnglishCard>> getCards() async {
    final db = await _dbService.database;
    final data = await db.query(EnglishCard.kTable,);
    return data.map((record) => EnglishCard.fromMap(record)).toList();
  }

  Future<EnglishCard> getCard(int id) async {
    final db = await _dbService.database;
    
    final data = await db.query(
      EnglishCard.kTable,
      where: '${EnglishCard.kId} = ?',
      whereArgs: [id]
    );

    return data.map((record) => EnglishCard.fromMap(record)).first;
  }

  Future<void> updateCard(EnglishCard card) async {
    final db = await _dbService.database;
    
    await db.update(
      EnglishCard.kTable,
      card.toMap(),
      where: '${EnglishCard.kId} = ?',
      whereArgs: [card.id]
    );
  }

  Future<bool> areCardsEmpty() async {
    final db = await _dbService.database;
    final data = await db.query(EnglishCard.kTable);

    return data.isEmpty;
  }

  Future<void> _deleteCard(int id) async {
    final db = await _dbService.database;

    await db.delete(
      EnglishCard.kTable, 
      where: '${EnglishCard.kId} = ?', 
      whereArgs: [id]
    );
  }

  Future<void> deleteCardAndConnections(int cardId) async {
    await _deleteCard(cardId); 
    await _groupLinksTableService.deleteLinksByCard(cardId);
    await _notesTableService.deleteNotesByCard(cardId);
  }


  Future<void> _deleteTable() async {
    final db = await _dbService.database;
    await db.delete(EnglishCard.kTable);
  }

  Future<void> deleteTableAndConnections() async {
    await _deleteTable(); 
    await _groupLinksTableService.deleteTable();
    await _notesTableService.deleteTable();
  }

  Future<bool> existsCardWithWord(String word) async {
    final db = await _dbService.database;

    final data = await db.query(
      EnglishCard.kTable, 
      where: '${EnglishCard.kWord} = ?',
      whereArgs: [word]
    );

    return data.isNotEmpty;
  }
}