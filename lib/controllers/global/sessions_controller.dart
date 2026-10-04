import 'package:flutter/material.dart';
import 'package:fproject/models/session.dart';
import 'package:fproject/services/table/sessions_table_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class SessionsController extends ChangeNotifier {
  final SessionsTableService _sessionsTableService;

  Map<int, Session> _sessions = {};
  Map<int, List<int>> _sessionGroupLinks = {};

  SessionsController(this._sessionsTableService) {
    init();
  }

  Future<void> init() async {
    for (final session in await _sessionsTableService.getAllSessions()) {
      final id = session.id;

      _sessions[id] = session;

      for (final link in await _sessionsTableService.getSessionGroupLinks(id)) {
        if (_sessionGroupLinks.containsKey(id)) {
          _sessionGroupLinks[id]!.add(link.groupId);
        }
        else {
          _sessionGroupLinks[id] = [link.groupId];
        }
      }
    }
  }

  Future<void> add(String name, List<int> groupIds) async {
    final id = await _sessionsTableService.add(name, groupIds);
    _sessions[id] = Session(id: id, name: name, currentCardId: null);
    _sessionGroupLinks[id] = groupIds;
    notifyListeners();
  }

  Future<void> updateName(int id, String name) async {
    final session = Session(id: id, name: name, currentCardId: null);
    await _sessionsTableService.updateName(id, name);
    _sessions[id] = session;
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _sessionsTableService.deleteSessionAndConnections(id);
    _sessions.remove(id);
    notifyListeners();
  }

  Future<void> deleteTable() async {
    await _sessionsTableService.deleteTableAndConnections();
    _sessions = {};
    _sessionGroupLinks = {};
    notifyListeners();
  }

  List<Session> getAll() {
    return _sessions.values.toList();
  }

  Session get(int id) {
    return _sessions[id]!; 
  }

  List<int> getGroupIds(int sessionId) {
    return _sessionGroupLinks[sessionId]!; 
  }

  int get length => _sessions.length;
}