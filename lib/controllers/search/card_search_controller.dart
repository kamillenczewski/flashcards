import 'package:fproject/controllers/search/abstract_search_controller.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class CardSearchController extends AbstractSearchController {
  final _cardsController = getIt<CardsController>();
  final _groupLinksTableService = getIt<GroupLinksTableService>();

  List<int> _visibleCardIds = [];
  String _lastQuery = '';

  CardSearchController() {
    _updateVisibleCards();
    _cardsController.addListener(_onCardsControllerChange);
    _groupLinksTableService.addListener(_onCardsControllerChange);
  }

  @override
  void dispose() {
    _cardsController.removeListener(_onCardsControllerChange);
    _groupLinksTableService.addListener(_onCardsControllerChange);
    super.dispose();
  }

  @override
  void updateQuery(String query) {
    _lastQuery = query;
    _updateVisibleCards();
  }

  @override
  int get length => _visibleCardIds.length;

  @override
  EnglishCard get(int index) {
    return _cardsController.get(_visibleCardIds[index]);
  }

  void _onCardsControllerChange() {
    _updateVisibleCards();
    notifyListeners();
  }

  void _updateVisibleCards() {
    _visibleCardIds = _cardsController.getAll().map((e) => e.id).toList();

    if (_lastQuery.trim().isEmpty) {
      notifyListeners();
      return;
    }
      
    _visibleCardIds = _visibleCardIds
      .where(
          (id) => 
            _cardsController.get(id).word.toLowerCase().contains(_lastQuery.toLowerCase()) || 
            _cardsController.get(id).explanation.toLowerCase().contains(_lastQuery.toLowerCase())
        )
      .toList();

    notifyListeners();
  }
}