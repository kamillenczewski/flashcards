import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/services/other/groups_and_quantity_service.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class GroupsAndQuantityController extends ChangeNotifier {
  final GroupsController _groupsController;
  final GroupsAndQuantityService _groupsAndQuantityService;
  final GroupLinksTableService _groupLinksTableService;
  Map<int, int> _groupIdsAndQuantity = {};

  GroupsAndQuantityController(
    this._groupsController, 
    this._groupsAndQuantityService,
    this._groupLinksTableService
  ) {
    _update();
    _groupsController.addListener(_onOtherControllerChange);
    _groupLinksTableService.addListener(_onOtherControllerChange);
  }

  void _onOtherControllerChange() {
    notifyListeners();
    _groupIdsAndQuantity = {};
    _update();
  }

  @override
  void dispose() {
    _groupsController.removeListener(_onOtherControllerChange);
    _groupLinksTableService.removeListener(_onOtherControllerChange);
    super.dispose();
  }

  Future<void> _update() async {
    for (final item in await _groupsAndQuantityService.get()) {
      _groupIdsAndQuantity[item.groupId] = item.quantity;
    }
  }

  List<int> getAll() {
    return _groupIdsAndQuantity.values.toList();
  }

  int getQuantity(int groupId) {
    return _groupIdsAndQuantity[groupId]!; 
  }

  int get length => _groupIdsAndQuantity.length;
}