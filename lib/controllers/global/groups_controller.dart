import 'package:flutter/material.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/services/table/group_table_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class GroupsController extends ChangeNotifier {
  final GroupTableService _groupTableService;
  Map<int, Group> _groups = {};

  GroupsController(this._groupTableService) {
    init();
  }

  Future<void> init() async {
    for (final card in await _groupTableService.getAllGroups()) {
      _groups[card.id] = card;
    }
  }

  Future<void> add(String name) async {
    final id = await _groupTableService.addGroup(name);
    _groups[id] = Group(id: id, name: name);
    notifyListeners();
  }

  Future<void> update(int id, String name) async {
    final item = Group(id: id, name: name);
    await _groupTableService.updateGroup(item);
    _groups[id] = item;
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _groupTableService.deleteGroupAndConnections(id);
    _groups.remove(id);
    notifyListeners();
  }

  Future<void> deleteTable() async {
    await _groupTableService.deleteTableAndConnections();
    _groups = {};
    notifyListeners();
  }

  List<Group> getAll() {
    return _groups.values.toList();
  }

  Group get(int id) {
    return _groups[id]!; 
  }

  int get length => _groups.length;
}