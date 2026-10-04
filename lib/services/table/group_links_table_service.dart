import 'package:flutter/material.dart';
import 'package:fproject/helper_models/card_condition.dart';
import 'package:fproject/helper_models/group_condition.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/models/group_link.dart';
import 'package:fproject/services/table/database_service.dart';

class GroupLinksTableService extends ChangeNotifier {
  final DatabaseService _dbService;

  GroupLinksTableService(this._dbService);

  Future<List<GroupLink>> getAll() async {
    final db = await _dbService.database;
    final data = await db.query(GroupLink.kTable);
    return data.map((e) => GroupLink.fromMap(e)).toList();
  }

  Future<int> addLink(int groupId, int cardId) async {
    final db = await _dbService.database;

    final id = await db.insert(
      GroupLink.kTable, 
      {
        GroupLink.kGroupId: groupId,
        GroupLink.kCardId: cardId,
      }
    );

    notifyListeners();

    return id;
  }

  Future<void> deleteLink(int groupId, int cardId) async {
    final db = await _dbService.database;

    await db.delete(
      GroupLink.kTable, 
      where: '${GroupLink.kGroupId} = ? AND ${GroupLink.kCardId} = ?',
      whereArgs: [groupId, cardId]
    );

    notifyListeners();
  }

  Future<void> deleteLinksByCard(int cardId) async {
    final db = await _dbService.database;

    await db.delete(
      GroupLink.kTable, 
      where: '${GroupLink.kCardId} = ?',
      whereArgs: [cardId]
    );

    notifyListeners();
  }

  Future<void> deleteLinksByGroup(int groupId) async {
    final db = await _dbService.database;

    await db.delete(
      GroupLink.kTable, 
      where: '${GroupLink.kGroupId} = ?',
      whereArgs: [groupId]
    );

    notifyListeners();
  }

  Future<void> deleteTable() async {
    final db = await _dbService.database;
    await db.delete(GroupLink.kTable);
    notifyListeners();
  }

  Future<List<GroupCondition>> getGroupConditionsForCard(int cardId) async {
    final db = await _dbService.database;
 
    final data = await db.rawQuery("""
      SELECT 
        ${Group.kId} AS ${GroupCondition.kGroupIdName},
        ${Group.kName} AS ${GroupCondition.kGroupNameName},
        CASE
          WHEN 
          ${Group.kId} IN (
            SELECT ${GroupLink.kGroupId}
            FROM ${GroupLink.kTable}
            WHERE ${GroupLink.kCardId} = $cardId
          ) 
          THEN 1
          ELSE 0
        END AS ${GroupCondition.kIsSatisfiedName}
      FROM ${Group.kTable}
    """);

    return data.map((record) => GroupCondition.fromMap(record)).toList();
  }

  Future<List<CardCondition>> getCardConditionsForGroup(int groupId) async {
    final db = await _dbService.database;
 
    final data = await db.rawQuery("""
      SELECT 
        ${EnglishCard.kId},
        ${EnglishCard.kWord},
        ${EnglishCard.kExplanation},
        CASE
          WHEN 
          ${EnglishCard.kId} IN (
            SELECT ${GroupLink.kCardId}
            FROM ${GroupLink.kTable}
            WHERE ${GroupLink.kGroupId} = $groupId
          ) 
          THEN 1
          ELSE 0
        END AS ${CardCondition.kIsSatisfied}
      FROM ${EnglishCard.kTable}
    """);

    return data.map((record) => CardCondition.fromMap(record)).toList();
  }

  Future<List<EnglishCard>> getCardsFromGroup(int groupId) async {
    final db = await _dbService.database;

    final data = await db.rawQuery("""
      SELECT 
        ${EnglishCard.kTable}.${EnglishCard.kId},
        ${EnglishCard.kTable}.${EnglishCard.kWord},
        ${EnglishCard.kTable}.${EnglishCard.kExplanation}
      FROM
        ${GroupLink.kTable}
      INNER JOIN
        ${EnglishCard.kTable}
      ON
        ${EnglishCard.kTable}.${EnglishCard.kId} 
        = 
        ${GroupLink.kTable}.${GroupLink.kCardId}
      WHERE
        ${GroupLink.kGroupId} = $groupId
    """);
    
    return data.map((e) => EnglishCard.fromMap(e)).toList();
  }

  Future<List<Group>> getGroupsFromCard(int cardId) async {
    final db = await _dbService.database;
   
    final data = await db.rawQuery("""
      SELECT 
        ${Group.kTable}.${Group.kId},
        ${Group.kTable}.${Group.kName}
      FROM
        ${GroupLink.kTable}
      INNER JOIN
        ${Group.kTable}
      ON
        ${Group.kTable}.${Group.kId} 
        = 
        ${GroupLink.kTable}.${GroupLink.kGroupId}
      WHERE
        ${GroupLink.kCardId} = $cardId
    """);

    return data.map((e) => Group.fromMap(e)).toList();
  }
}