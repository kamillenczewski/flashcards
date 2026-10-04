import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/search/group_and_quantity_search_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/modals/accept_action_dialog.dart';
import 'package:fproject/modals/create_group_dialog.dart';
import 'package:fproject/modals/edit_group_dialog.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/pages/custom_search_bar.dart';
import 'package:fproject/pages/widgets/custom_menu_button.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/widgets/group_list_item.dart';
import 'package:fproject/pages/add_cards_to_group_page.dart';
import 'package:fproject/pages/cards_in_group_page.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;


class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  static const routeName = '/GroupsPage';

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final _language = getIt<LanguageController>();
  final _groupsController = getIt<GroupsController>();
  final _groupAndQuantitySearchController = GroupAndQuantitySearchController();

  Widget createCardsQuantityWidget(int quantity) {
    final settings = context.watch<SettingsController>();

    if (quantity == 0) return Text('');
    
    return Text(
      '$quantity ${quantity == 1 ? 'Card' : 'Cards'}',
      style: TextStyle(
        fontFamily: settings.fontFamily, 
        color: settings.innerColor,
        fontWeight: .bold
      ),
    );
  }

  Widget createWidgetForAll(Group group) {
    // from source code
    final minHeight = 48.0; 
    final minWidth = 48.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
      child: SizedBox.shrink()
    );
  }

  Widget createPopupMenuButtonForFavorite(Group group) {
    return CustomMenuButton(
      itemsData: [
        (
          label: _language['Add card'], 
          icon: Icons.add, 
          callback: () async {
            await Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, _, _) => AddCardsToGroupPage(group),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, _, _, child) => child,
              )
            );
            setState(() {});
          }
        ),
        (
          label: _language['Show cards'], 
          icon: Icons.my_library_books_rounded,
          callback: () async { 
            await Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, _, _) => CardsInGroupPage(group),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, _, _, child) => child,
              )
            );
            setState(() {});
          }
        ), 
      ]
    );
  }

  Widget createPopupMenuButton(Group group) {
    return CustomMenuButton(
      itemsData: [
        (
          label: _language['Add card'], 
          icon: Icons.add, 
          callback: () async {
            await Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, _, _) => AddCardsToGroupPage(group),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, _, _, child) => child,
              )
            );
            setState(() {});
          }
        ),
        (
          label: _language['Edit'], 
          icon: Icons.edit, 
          callback: () => showEditGroupDialog(context, setState, group),
        ),
        (
          label: _language['Delete'], 
          icon: Icons.delete, 
          callback: () => 
            showAcceptActionDialog(
              context, 
              () async {
                await _groupsController.delete(group.id);
                setState(() {});
              }, 
              "${_language['Are you sure you want to delete']}: ${group.name.toString()}"
            ),
        ),
        (
          label: _language['Show cards'], 
          icon: Icons.my_library_books_rounded,
          callback: () async { 
            await Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, _, _) => CardsInGroupPage(group),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, _, _, child) => child,
              )
            );
            setState(() {});
          }
        ), 
      ]
    );
  }

  Widget createRightWidget(Group group) {
    if (group.id == Group.kAllGroup.id) {
      return createWidgetForAll(group);
    } 
    else if (group.id == Group.kFavoriteGroup.id) {
      return createPopupMenuButtonForFavorite(group);
    }
    else {
      return createPopupMenuButton(group);
    }
  }

  Widget createListItem(Group group, int quantity) {
    return GroupListItem(
      group: group, 
      rightWidget: Row(
        spacing: 10,
        children: [
          createCardsQuantityWidget(quantity),
          createRightWidget(group)
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    // double windowWidth = MediaQuery.of(context).size.width;
    // double windowHeight = MediaQuery.of(context).size.height;
    // print(windowWidth);
    // print(windowHeight);
    return Container(
      color: settings.outerColor,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: _groupAndQuantitySearchController, 
          builder: (context, child) {
            return Column(
              spacing: 4,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _language['Groups'],
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        fontFamily: settings.fontFamily,
                        color: settings.innerColor
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCreateGroupDialog(context, setState);
                      }, 
                      icon: Icon(Icons.add, color: settings.innerColor)
                    ),
                    CustomSearchBar(searchController: _groupAndQuantitySearchController)
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _groupAndQuantitySearchController.length,
                    itemBuilder: (context, index) => 
                      createListItem(_groupAndQuantitySearchController.get(index).group, _groupAndQuantitySearchController.get(index).quantity)
                  ),
                )
              ],
            );
          }
        ) 
      ),
    );
  }
}