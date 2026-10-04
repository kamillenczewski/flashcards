import 'package:flutter/material.dart';
import 'package:fproject/controllers/search/card_search_controller.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/accept_action_dialog.dart';
import 'package:fproject/modals/create_card_dialog.dart';
import 'package:fproject/modals/edit_card_dialog.dart';
import 'package:fproject/modals/link_group_to_card_modal.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/pages/custom_search_bar.dart';
import 'package:fproject/pages/widgets/card_list_item.dart';
import 'package:fproject/pages/widgets/custom_menu_button.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/groups_for_card_page.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  static const routeName = '/CardsPage';

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final _language = getIt<LanguageController>();
  final _cardsController = getIt<CardsController>();
  final _cardSearchController = CardSearchController();

  Widget createPopupMenuButton(EnglishCard card) {
    return CustomMenuButton(
      itemsData: [
        (
          label: _language['Add to group'], 
          icon: Icons.add, 
          callback: () => showLinkGroupToCardModal(context, setState, card.id)
        ),
        (
          label: _language['Edit'], 
          icon: Icons.edit, 
          callback: () => showEditCardDialog(context, setState, card)
        ),
        (
          label: _language['Delete'], 
          icon: Icons.delete, 
          callback: () => 
          showAcceptActionDialog(
            context, 
            () {
              _cardsController.delete(card.id);
              setState(() {});
            }, 
            "${_language['Are you sure you want to delete']}: ${card.word.toString()}" 
          )
        ),
        (
          label: _language['Show groups'], 
          icon: Icons.grid_view_rounded, 
          callback: () => 
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, _, _) => GroupsForCardPage(card),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, _, _, child) => child,
              )
          )
        ), 
      ]
    );
  }


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    
    return ListenableBuilder(
      listenable: _cardSearchController,
      builder: (context, child) =>
        Container(
          color: settings.outerColor,
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _language['Cards'],
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        fontFamily: settings.fontFamily,
                        color: settings.innerColor
                      ),
                    ),
                    IconButton(
                      onPressed: () => showCreateCardDialog(context, setState), 
                      icon: Icon(Icons.add, color: settings.innerColor)
                    ),
                    CustomSearchBar(searchController: _cardSearchController)
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: _cardSearchController.length,
                    itemBuilder: (context, index) => 
                      CardListItem(
                        card: _cardSearchController.get(index), 
                        rightWidget: createPopupMenuButton(_cardSearchController.get(index))
                      ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}

