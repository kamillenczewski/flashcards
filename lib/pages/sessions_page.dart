import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/sessions_controller.dart';
import 'package:fproject/controllers/search/session_search_controller.dart';
import 'package:fproject/modals/accept_action_dialog.dart';
import 'package:fproject/modals/create_session_dialog.dart';
import 'package:fproject/models/session.dart';
import 'package:fproject/pages/current_session_page.dart';
import 'package:fproject/pages/custom_search_bar.dart';
import 'package:fproject/pages/widgets/custom_menu_button.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/widgets/session_list_item.dart';
import 'package:fproject/services/other/new_session_shuffle_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  static const routeName = '/SessionsPage';

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final _language = getIt<LanguageController>();
  final _sessionSearchController = SessionSearchController();
  final _sessionsController = getIt<SessionsController>();
  final _groupsController = getIt<GroupsController>();
  final _newSessionShuffleService = getIt<NewSessionShuffleService>();

  Widget createPopupMenuButton(Session session) {
    return CustomMenuButton(
      itemsData: [
        (
          label: _language['Delete'], 
          icon: Icons.delete, 
          callback: () => showAcceptActionDialog(
            context,
            () {
              _sessionsController.delete(session.id);
            },
            _language["Are you sure you want to delete session with name: '${session.name}'"]
          )
        ),
        (
          label: _language['Edit name '], 
          icon: Icons.edit, 
          callback: () => {}
        ),
        (
          label: _language['New shuffle'], 
          icon: Icons.open_in_new, 
          callback: () async {
            await _newSessionShuffleService.execute(session.id);
          }
        ),
        (
          label: _language['Resume'], 
          icon: Icons.open_in_new, 
          callback: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, _, _) => CurrentSessionPage(),
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
      listenable: _sessionSearchController,
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
                      _language['Sessions'],
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        fontFamily: settings.fontFamily,
                        color: settings.innerColor
                      ),
                    ),
                    IconButton(
                      onPressed: () => showCreateSessionDialog(context),
                      icon: Icon(Icons.add, color: settings.innerColor)
                    ),
                    CustomSearchBar(searchController: _sessionSearchController)
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: _sessionSearchController.length,
                    itemBuilder: (context, index) {
                      final session = _sessionSearchController.get(index);
                      final groups = _sessionsController
                        .getGroupIds(session.id)
                        .map((id) => _groupsController.get(id))
                        .toList();
                      
                      return SessionListItem(
                        session: session, 
                        groups: groups, 
                        rightWidget: createPopupMenuButton(session)
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}