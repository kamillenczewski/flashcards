import 'package:fproject/models/settings_item.dart';
import 'package:fproject/services/table/database_service.dart';

class SettingsTableService {
  final DatabaseService _dbService;

  SettingsTableService(this._dbService);

  Future<String> getValue(String itemName) async{
    final db = await _dbService.database;

    final data = await db.query(
      SettingsItem.kTable,
      where: '${SettingsItem.kName} = ?',
      whereArgs: [itemName]
    );

    return data.map((e) => SettingsItem.fromMap(e)).first.value;
  }

  Future<void> setValue(String itemName, String value) async{
    final db = await _dbService.database;

    await db.update(
      SettingsItem.kTable,
      {
        SettingsItem.kName: itemName,
        SettingsItem.kValue: value,
      },
      where: '${SettingsItem.kName} = ?',
      whereArgs: [itemName]
    );
  }
}