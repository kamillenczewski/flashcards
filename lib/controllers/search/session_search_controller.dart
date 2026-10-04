import 'package:fproject/controllers/global/sessions_controller.dart';
import 'package:fproject/controllers/search/abstract_search_controller.dart';
import 'package:fproject/models/session.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class SessionSearchController extends AbstractSearchController {
  final _sessionsController = getIt<SessionsController>();

  List<int> _visibleIds = [];
  String _lastQuery = '';

  SessionSearchController() {
    _updateVisibleItems();
    _sessionsController.addListener(_onOtherControllerChange);
  }

  @override
  void dispose() {
    _sessionsController.removeListener(_onOtherControllerChange);
    super.dispose();
  }

  @override
  void updateQuery(String query) {
    _lastQuery = query;
    _updateVisibleItems();
  }

  @override
  int get length => _visibleIds.length;

  @override
  Session get(int index) {
    return _sessionsController.get(_visibleIds[index]);
  }

  void _onOtherControllerChange() {
    _updateVisibleItems();
    notifyListeners();
  }

  void _updateVisibleItems() {
    _visibleIds = _sessionsController.getAll().map((e) => e.id).toList();

    if (_lastQuery.trim().isEmpty) {
      notifyListeners();
      return;
    }
      
    _visibleIds = _visibleIds
      .where(
          (id) => _sessionsController.get(id).name.toLowerCase().contains(_lastQuery.toLowerCase())
        )
      .toList();

    notifyListeners();
  }
}