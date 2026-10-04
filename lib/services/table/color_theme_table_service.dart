import 'package:fproject/models/color_theme.dart';
import 'package:fproject/services/table/database_service.dart';

class ColorThemeTableService {
  final DatabaseService _dbService;

  ColorThemeTableService(this._dbService);

  Future<int> add(String name, String inner, String outer, String middle) async {
    final db = await _dbService.database;

    return await db.insert(
      ColorTheme.kTable, 
      {
        ColorTheme.kName: name,
        ColorTheme.kInnerColor: inner,
        ColorTheme.kOuterColor: outer,
        ColorTheme.kMiddleColor: middle,
      }
    );
  }

  Future<ColorTheme> get(int id) async {
    final db = await _dbService.database;
  
    final data = await db.query(
      ColorTheme.kTable,
      where: '${ColorTheme.kId} = ?',
      whereArgs: [id]
    );

    return data.map((e) => ColorTheme.fromMap(e)).first;
  }

  Future<List<ColorTheme>> getAll() async {
    final db = await _dbService.database;
    final data = await db.query(ColorTheme.kTable);
    return data.map((e) => ColorTheme.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    final db = await _dbService.database;
    
    await db.delete(
      ColorTheme.kTable,
      where: '${ColorTheme.kId} = ?',
      whereArgs: [id]
    );
  }

  Future<void> update(int id, String name, String inner, String outer, String middle) async {
    final db = await _dbService.database;
    
    await db.update(
      ColorTheme.kTable,
      {
        ColorTheme.kId: id,
        ColorTheme.kName: name,
        ColorTheme.kInnerColor: inner,
        ColorTheme.kOuterColor: outer,
        ColorTheme.kMiddleColor: middle,
      },
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}