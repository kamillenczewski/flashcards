import 'package:fproject/models/color_theme.dart';
import 'package:fproject/models/english_card.dart';
import 'package:fproject/models/group.dart';
import 'package:fproject/models/group_link.dart';
import 'package:fproject/models/note.dart';
import 'package:fproject/models/session.dart';
import 'package:fproject/models/session_card_link.dart';
import 'package:fproject/models/session_group_link.dart';
import 'package:fproject/models/settings_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  final String kDbPath = "MyDb_41.db";

  final String kCardsTable = """
    CREATE TABLE ${EnglishCard.kTable} (
      ${EnglishCard.kId} INTEGER PRIMARY KEY,
      ${EnglishCard.kWord} TEXT NOT NULL UNIQUE,
      ${EnglishCard.kExplanation} TEXT NOT NULL
    )
  """;

  final String kNotesTable = """
    CREATE TABLE ${Note.kTable} (
      ${Note.kId} INTEGER PRIMARY KEY,
      ${Note.kCardId} INTEGER NOT NULL,
      ${Note.kContent} TEXT NOT NULL
    )
  """;
  
  final String kGroupsTable = """
    CREATE TABLE ${Group.kTable} (
      ${Group.kId} INTEGER PRIMARY KEY,
      ${Group.kName} TEXT NOT NULL UNIQUE
    )
  """;

  final String kGroupLinksTable = """
    CREATE TABLE ${GroupLink.kTable} (
      ${GroupLink.kId} INTEGER PRIMARY KEY,
      ${GroupLink.kGroupId} INTEGER NOT NULL,
      ${GroupLink.kCardId} INTEGER NOT NULL
    )
  """;

  final String kSettingsTable = """
    CREATE TABLE ${SettingsItem.kTable} (
      ${SettingsItem.kId} INTEGER PRIMARY KEY,
      ${SettingsItem.kName} TEXT NOT NULL UNIQUE,
      ${SettingsItem.kValue} TEXT
    )
  """;

  final String kColorThemesTable = """
    CREATE TABLE ${ColorTheme.kTable} (
      ${ColorTheme.kId} INTEGER PRIMARY KEY,
      ${ColorTheme.kName} TEXT NOT NULL UNIQUE,
      ${ColorTheme.kInnerColor} TEXT NOT NULL,
      ${ColorTheme.kOuterColor} TEXT NOT NULL,
      ${ColorTheme.kMiddleColor} TEXT NOT NULL
    )
  """;

  final String kSessionsTable = """
    CREATE TABLE ${Session.kTable} (
      ${Session.kId} INTEGER PRIMARY KEY,
      ${Session.kName} TEXT NOT NULL UNIQUE,
      ${Session.kCurrentCardId} INTEGER
    )
  """;

  final String kSessionGroupLinksTable = """
    CREATE TABLE ${SessionGroupLink.kTable} (
      ${SessionGroupLink.kId} INTEGER PRIMARY KEY,
      ${SessionGroupLink.kGroupId} INTEGER NOT NULL,
      ${SessionGroupLink.kSessionId} INTEGER NOT NULL
    )
  """;

  final String kSessionCardLinksTable = """
    CREATE TABLE ${SessionCardLink.kTable} (
      ${SessionCardLink.kId} INTEGER PRIMARY KEY,
      ${SessionCardLink.kCardId} INTEGER NOT NULL,
      ${SessionCardLink.kSessionId} INTEGER NOT NULL
    )
  """;

  Future<Database> get database  async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, kDbPath);

    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(kCardsTable);
        db.execute(kNotesTable);
        db.execute(kGroupLinksTable);
        db.execute(kSessionsTable);
        db.execute(kSessionCardLinksTable);
        db.execute(kSessionGroupLinksTable);

        db.execute(kSettingsTable);
        db.insert(SettingsItem.kTable, SettingsItem.fontFamilyItem.toMap());
        db.insert(SettingsItem.kTable, SettingsItem.colorThemeIdItem.toMap());
        db.insert(SettingsItem.kTable, SettingsItem.languageItem.toMap());

        db.execute(kGroupsTable);
        db.insert(Group.kTable, Group.kFavoriteGroup.toMap());
        db.insert(Group.kTable, Group.kAllGroup.toMap());

        db.execute(kColorThemesTable);
        db.insert(ColorTheme.kTable, ColorTheme.kDarkTheme.toMap());
        db.insert(ColorTheme.kTable, ColorTheme.kLightTheme.toMap());
      }
    );
    return db;
  }
}