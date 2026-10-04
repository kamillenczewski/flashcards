import 'package:fproject/models/session.dart';
import 'package:fproject/models/session_card_link.dart';
import 'package:fproject/models/session_group_link.dart';
import 'package:fproject/services/table/database_service.dart';

class SessionsTableService {
  final DatabaseService _dbService;

  SessionsTableService(
    this._dbService,
  );

  Future<int> add(String name, List<int> groupIds) async {
    final db = await _dbService.database;

    final sessionId = await db.insert(
      Session.kTable, 
      {
        Session.kName: name,
      }
    );
    
    for (final groupId in groupIds) {
      await db.insert(
        SessionGroupLink.kTable, 
        {
          SessionGroupLink.kSessionId: sessionId,
          SessionGroupLink.kGroupId: groupId,
        }
      );
    }

    return sessionId;
  }

  Future<List<Session>> getAllSessions() async {
    final db = await _dbService.database;
    final data = await db.query(Session.kTable);
    return data.map((e) => Session.fromMap(e)).toList();
  }

  Future<List<SessionGroupLink>> getSessionGroupLinks(int sessionId) async {
    final db = await _dbService.database;

    final data = await db.query(
      SessionGroupLink.kTable,
      where: '${SessionGroupLink.kSessionId} = ?',
      whereArgs: [sessionId]
    );

    return data.map((e) => SessionGroupLink.fromMap(e)).toList();
  }

  Future<void> updateName(int id, String name) async {
    final db = await _dbService.database;

    await db.update(
      Session.kTable, 
      {
        Session.kId: id,
        Session.kName: name
      },
      where: '${Session.kId} = ?',
      whereArgs: [id]
    );
  }

  Future<void> deleteSessionAndConnections(int id) async {
    final db = await _dbService.database;

    await db.delete(
      Session.kTable,
      where: '${Session.kId} = ?',
      whereArgs: [id]
    );

    await db.delete(
      SessionGroupLink.kTable,
      where: '${SessionGroupLink.kSessionId} = ?',
      whereArgs: [id]
    );

    await db.delete(
      SessionCardLink.kTable,
      where: '${SessionCardLink.kSessionId} = ?',
      whereArgs: [id]
    );
  }

  Future<void> deleteTableAndConnections() async {
    final db = await _dbService.database;

    await db.delete(Session.kTable);
    await db.delete(SessionGroupLink.kTable);
    await db.delete(SessionCardLink.kTable);
  }
}