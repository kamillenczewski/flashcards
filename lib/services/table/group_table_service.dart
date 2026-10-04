import 'package:fproject/models/group.dart';
import 'package:fproject/services/table/database_service.dart';
import 'package:fproject/services/table/group_links_table_service.dart';

class GroupTableService {
  final DatabaseService _dbService;
  final GroupLinksTableService _groupLinksTableService;

  GroupTableService(
    this._dbService,
    this._groupLinksTableService,
  );

  Future<int> addGroup(String name) async {
    final db = await _dbService.database;

    return await db.insert(
      Group.kTable, 
      {
        Group.kName: name,
      }
    );
  }

  Future<List<Group>> getAllGroups() async {
    final db = await _dbService.database;
    final data = await db.query(Group.kTable,);
    return data.map((record) => Group.fromMap(record)).toList();
  }

  Future<bool> exists(int id) async {
    final db = await _dbService.database;

    final data = await db.query(
      Group.kTable,
      where: '${Group.kId} = ?', 
      whereArgs: [id]
    ); 

    return data.isNotEmpty;
  }

  Future<String> getGroupName(int id) async {
    final db = await _dbService.database;

    final data = await db.query(
      Group.kTable,
      where: '${Group.kId} = ?', 
      whereArgs: [id],
      columns: [Group.kName]
    ); 

    return data.first[Group.kName] as String;
  }

  Future<void> _deleteGroup(int id) async {
    if (Group.permanentGroupNames.contains(await getGroupName(id))) return;

    final db = await _dbService.database;

    await db.delete(
      Group.kTable, 
      where: '${Group.kId} = ?', 
      whereArgs: [id]
    );
  }

  Future<void> deleteGroupAndConnections(int id) async {
    // if (!await exists(id)) return;

    await _deleteGroup(id);
    await _groupLinksTableService.deleteLinksByGroup(id);
  }

  Future<void> _deleteTable() async {
    final db = await _dbService.database;
    await db.delete(Group.kTable);
  }

  Future<void> deleteTableAndConnections() async {
    await _deleteTable();
    await _groupLinksTableService.deleteTable();
  }

  Future<void> updateGroup(Group group) async {
    final db = await _dbService.database;
    
    await db.update(
      Group.kTable,
      group.toMap(),
      where: '${Group.kId} = ?',
      whereArgs: [group.id]
    );
  }
}