import 'package:fproject/models/group.dart';
import 'package:fproject/models/group_link.dart';
import 'package:fproject/models/session.dart';
import 'package:fproject/models/session_card_link.dart';
import 'package:fproject/models/session_group_link.dart';
import 'package:fproject/services/table/database_service.dart';

class NewSessionShuffleService {
  final DatabaseService _dbService;

  NewSessionShuffleService(this._dbService);

  Future<void> execute(int sessionId) async {
    final db = await _dbService.database;

    await db.delete(
      SessionCardLink.kTable, 
      where: '${SessionCardLink.kSessionId} = ?',
      whereArgs: [sessionId]
    );

    final data = await db.rawQuery("""
      SELECT
        ${GroupLink.kTable}.${GroupLink.kCardId}
      FROM
        ${SessionGroupLink.kTable}
      INNER JOIN
        ${Group.kTable}
      ON
        ${SessionGroupLink.kTable}.${SessionGroupLink.kGroupId} = ${Group.kTable}.${Group.kId}
      INNER JOIN
        ${GroupLink.kTable}
      ON
        ${Group.kTable}.${Group.kId} = ${GroupLink.kTable}.${GroupLink.kGroupId}
      WHERE
        ${SessionGroupLink.kTable}.${SessionGroupLink.kSessionId} = $sessionId
    """);

    final cardIds = data.map((e) => e[GroupLink.kCardId]).toList();

    for (final cardId in cardIds) {
      await db.insert(
        SessionCardLink.kTable,
        {
          SessionCardLink.kSessionId: sessionId,
          SessionCardLink.kCardId: cardId,
        }
      );
    }

    await db.update(
      Session.kTable, 
      {
        Session.kId: sessionId,
        Session.kCurrentCardId: cardIds[0],
      }
    );
  }
}