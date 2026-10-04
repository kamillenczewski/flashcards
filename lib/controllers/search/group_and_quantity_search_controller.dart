import 'package:fproject/controllers/global/groups_and_quantity_controller.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/search/abstract_search_controller.dart';
import 'package:fproject/helper_models/group_and_cards_quantity.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class GroupAndQuantitySearchController extends AbstractSearchController<GroupAndCardsQuantity> {
  final _quantityController = getIt<GroupsAndQuantityController>();
  final _groupsController = getIt<GroupsController>();
  List<int> _visibleIds = [];
  String _lastQuery = '';

  GroupAndQuantitySearchController() {
    _updateVisibleIds();
    _groupsController.addListener(onOtherControllerChange);
  }

  @override
  void dispose() {
    _groupsController.removeListener(onOtherControllerChange);
    super.dispose();
  }

  @override
  void updateQuery(String query) {
    _lastQuery = query;
    _updateVisibleIds();
  }

  @override
  int get length => _visibleIds.length;

  @override
  GroupAndCardsQuantity get(int index) {
    return GroupAndCardsQuantity(
      quantity: _quantityController.getQuantity(_visibleIds[index]), 
      group: _groupsController.get(_visibleIds[index])
    );
  }

  void onOtherControllerChange() {
    _updateVisibleIds();
    notifyListeners();
  }

  void _updateVisibleIds() {
    _visibleIds = _groupsController.getAll().map((e) => e.id).toList();

    if (_lastQuery.trim().isEmpty) {
      notifyListeners();
      return;
    }

    _visibleIds = _visibleIds
      .where(
          (id) => 
            _groupsController.get(id).name.toLowerCase().contains(_lastQuery.toLowerCase())
        )
      .toList();

    notifyListeners();
  }
}