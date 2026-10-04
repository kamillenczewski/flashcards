import 'package:fproject/models/group.dart';
import 'package:fproject/models/group_link.dart';
import 'package:fproject/services/table/database_service.dart';

class GroupsAndQuantityService {
  final DatabaseService _dbService;

  static const kQuantity = 'quantity';

  GroupsAndQuantityService(this._dbService);

  Future<List<({int groupId, int quantity})>> get() async {
    final db = await _dbService.database;

    final data = await db.rawQuery("""
      SELECT 
        ${Group.kTable}.${Group.kId},
        COUNT(${GroupLink.kTable}.${GroupLink.kCardId}) AS $kQuantity
      FROM 
        ${Group.kTable} 
      FULL JOIN 
        ${GroupLink.kTable}
      ON 
        ${Group.kTable}.${Group.kId} = 
        ${GroupLink.kTable}.${GroupLink.kGroupId}
      GROUP BY 
        ${Group.kTable}.${Group.kId}, 
        ${Group.kTable}.${Group.kName} 
    """);

    return data.map((record) => 
      (
        groupId: record[Group.kId] as int, 
        quantity: record[kQuantity] as int
      )
    ).toList();
  }
}