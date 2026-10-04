import 'package:fproject/models/note.dart';
import 'package:fproject/services/table/database_service.dart';

class NotesTableService {
  final DatabaseService _dbService;

  NotesTableService(this._dbService);

  Future<int> addNote(int cardId, String content) async {
    final db = await _dbService.database;

    return await db.insert(
      Note.kTable, 
      {
        Note.kCardId: cardId,
        Note.kContent: content,
      }
    );
  }

  Future<List<Note>?> getNotes(int cardId) async {
    final db = await _dbService.database;

    final data = await db.query(
      Note.kTable, 
      where: "${Note.kCardId} = ?", 
      whereArgs: [cardId]
    );
    
    return data.map((record) => Note.fromMap(record)).toList();
  }

  Future<void> deleteNote(int id) async {
    final db = await _dbService.database;
    
    await db.delete(
      Note.kTable, 
      where: '${Note.kId} = ?', 
      whereArgs: [id]
    );
  }

  Future<void> deleteNotesByCard(int cardId) async {
    final db = await _dbService.database;
    
    await db.delete(
      Note.kTable, 
      where: '${Note.kCardId} = ?', 
      whereArgs: [cardId]
    );
  }

  Future<void> updateNote(int id, int cardId, String content) async {
    final db = await _dbService.database;
    
    await db.update(
      Note.kTable, 
      {
        Note.kId: id,
        Note.kCardId: cardId,
        Note.kContent: content,
      },
      where: '${Note.kId} = ?', 
      whereArgs: [id]
    );
  }

  Future<void> deleteTable() async {
    final db = await _dbService.database;
    await db.delete(Note.kTable);
  }
}