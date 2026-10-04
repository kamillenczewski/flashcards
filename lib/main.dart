import 'package:flutter/material.dart';
import 'package:fproject/controllers/global/cards_controller.dart';
import 'package:fproject/controllers/global/color_themes_controller.dart';
import 'package:fproject/controllers/global/groups_and_quantity_controller.dart';
import 'package:fproject/controllers/global/groups_controller.dart';
import 'package:fproject/controllers/global/language_controller.dart';
import 'package:fproject/controllers/global/sessions_controller.dart';
import 'package:fproject/pages/sessions_page.dart';
import 'package:fproject/services/other/groups_and_quantity_service.dart';
import 'package:fproject/services/other/new_session_shuffle_service.dart';
import 'package:fproject/services/table/color_theme_table_service.dart';
import 'package:fproject/controllers/global/settings_controller.dart';
import 'package:fproject/pages/cards_page.dart';
import 'package:fproject/pages/groups_page.dart';
import 'package:fproject/pages/settings_page/settings_page.dart';
import 'package:fproject/services/table/cards_table_service.dart';
import 'package:fproject/services/table/database_service.dart';
import 'package:fproject/services/table/group_links_table_service.dart';
import 'package:fproject/services/table/group_table_service.dart';
import 'package:fproject/services/table/notes_table_service.dart';
import 'package:fproject/services/table/sessions_table_service.dart';
import 'package:fproject/services/table/settings_table_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void registerServices() {
  // table-services
  getIt.registerSingleton<DatabaseService>(DatabaseService.instance);
  getIt.registerSingleton<NewSessionShuffleService>(NewSessionShuffleService(getIt<DatabaseService>()));
  getIt.registerSingleton<ColorThemeTableService>(ColorThemeTableService(getIt<DatabaseService>()));
  getIt.registerSingleton<SettingsTableService>(SettingsTableService(getIt<DatabaseService>()));
  getIt.registerSingleton<GroupLinksTableService>(GroupLinksTableService(getIt<DatabaseService>()));
  getIt.registerSingleton<NotesTableService>(NotesTableService(getIt<DatabaseService>()));
  getIt.registerSingleton<SessionsTableService>(SessionsTableService(getIt<DatabaseService>()));

  getIt.registerSingleton<CardsTableService>(CardsTableService(
    getIt<DatabaseService>(),
    getIt<GroupLinksTableService>(),
    getIt<NotesTableService>(),
  ));
  
  getIt.registerSingleton<GroupTableService>(GroupTableService(
    getIt<DatabaseService>(),
    getIt<GroupLinksTableService>(),
  ));

  getIt.registerSingleton<GroupsAndQuantityService>(GroupsAndQuantityService(getIt<DatabaseService>()));

  // controllers
  getIt.registerSingleton<SessionsController>(SessionsController(getIt<SessionsTableService>()));
  getIt.registerSingleton<ColorThemesController>(ColorThemesController());
  getIt.registerSingleton<LanguageController>(LanguageController());

  getIt.registerSingleton<SettingsController>(SettingsController(
    getIt<SettingsTableService>(), 
    getIt<ColorThemesController>(),
    getIt<LanguageController>(),
  ));

  getIt.registerSingleton<CardsController>(CardsController(getIt<CardsTableService>()));
  getIt.registerSingleton<GroupsController>(GroupsController(getIt<GroupTableService>()));
  getIt.registerSingleton<GroupsAndQuantityController>(GroupsAndQuantityController(
    getIt<GroupsController>(),
    getIt<GroupsAndQuantityService>(),
    getIt<GroupLinksTableService>(),
  ));
}

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  registerServices();

  final settingsController = getIt<SettingsController>();
  final colorThemesController = getIt<ColorThemesController>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsController),
        ChangeNotifierProvider(create: (_) => colorThemesController),
      ],
      child: MaterialApp(
        home: MainShell()
      ),
    ) 
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _nestedNavigatorKey = GlobalKey<NavigatorState>();
  final _language = getIt<LanguageController>();

  final _pages = {
    SessionsPage.routeName: SessionsPage(),
    CardsPage.routeName: CardsPage(),
    GroupsPage.routeName: GroupsPage(),
    SettingsPage.routeName: SettingsPage(),
  };

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    final pagesData = [
      (_language['Sessions'], SessionsPage.routeName, Icons.my_library_books_rounded),
      (_language['Cards'], CardsPage.routeName, Icons.my_library_books_rounded),
      (_language['Groups'], GroupsPage.routeName, Icons.grid_view_rounded),
      (_language['Settings'], SettingsPage.routeName, Icons.settings),
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: settings.outerColor, foregroundColor: settings.innerColor),
      drawer: Drawer(
        backgroundColor: settings.outerColor,
        child: ListView.builder(
          itemCount: pagesData.length,
          itemBuilder: (context, index) {
            final (name, route, icon) = pagesData[index];
    
            return ListTile(
              key: ValueKey(route),
              title: Row(
                children: [
                  Icon(icon, color: settings.innerColor, size: 23),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      name, 
                      style: TextStyle(
                        color: settings.innerColor, 
                        fontFamily: settings.fontFamily, 
                        fontSize: 18
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                _nestedNavigatorKey.currentState?.pushReplacementNamed(route);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Navigator(
        key: _nestedNavigatorKey,
        initialRoute: CardsPage.routeName,
        onGenerateRoute: (RouteSettings settings) {
          final page = _pages[settings.name] ?? SessionsPage();
          
          return PageRouteBuilder(
            pageBuilder: (_, _, _) => page,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            transitionsBuilder: (_, _, _, child) => child,
          );
        },
      ),
    );
  }
}