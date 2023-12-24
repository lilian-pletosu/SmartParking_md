import 'package:smart_parking_md/data/models/models.dart';
import 'package:smart_parking_md/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CityDatasource {
  static final CityDatasource _instance = CityDatasource._();
  factory CityDatasource() => _instance;

  CityDatasource._() {
    _initDB();
  }

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DBKeys.dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE ${DBKeys.licensePlatestTble} (
        ${DBKeys.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBKeys.licensePlateColumn} TEXT
      )
      ''');
  }

  Future<int> addLicensePlate(LicensePlate licensePlate) async {
    final db = await database;
    return db.transaction((txn) async => await txn.insert(
          DBKeys.licensePlatestTble,
          licensePlate.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));
  }

  Future<int> updateLicensePlate(LicensePlate licensePlate) async {
    final db = await database;
    return db.transaction(
      (txn) async => await txn.update(
        DBKeys.licensePlatestTble,
        licensePlate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
  }

  Future<int> removeLicensePlate(LicensePlate licensePlate) async {
    final db = await database;
    return db.transaction((txn) async => await txn.delete(
          DBKeys.licensePlatestTble,
          where: 'id = ?',
          whereArgs: [licensePlate.id],
        ));
  }

  Future<List<LicensePlate>> getAllLicensesPlates() async {
    final db = await database;
    final List<Map<String, dynamic>> data =
        await db.query(DBKeys.licensePlatestTble, orderBy: "id DESC");
    return List.generate(
        data.length, (index) => LicensePlate.fromJson(data[index]));
  }
}
