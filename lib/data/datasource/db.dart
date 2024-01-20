import 'dart:async';

import 'package:smart_parking_md/data/models/models.dart';
import 'package:smart_parking_md/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._();
  factory DbHelper() => _instance;

  DbHelper._() {
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
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.transaction((txn) async {
      await txn.execute('''
      CREATE TABLE ${LicensePlateFields.licensePlateTable} (
        ${LicensePlateFields.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${LicensePlateFields.licensePlateColumn} TEXT,
        ${LicensePlateFields.statusColumn} INTEGER NOT NULL DEFAULT 1
      )
    ''');

      await txn.execute('''
      CREATE TABLE ${CityFields.cityTable} (
        ${CityFields.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${CityFields.nameColumn} TEXT
      )
    ''');

      await txn.execute('''
      CREATE TABLE ${ZoneFields.zoneTable} (
        ${ZoneFields.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ZoneFields.nameColumn} TEXT NOT NULL,
        ${ZoneFields.tarifColumn} REAL NOT NULL,
        ${ZoneFields.maxParkingColumn} TEXT NOT NULL,
        ${ZoneFields.cityIdColumn} INTEGER NOT NULL
      )
    ''');

      await txn.execute('''
      INSERT INTO ${CityFields.cityTable} (${CityFields.idColumn}, ${CityFields.nameColumn})
      VALUES
        (1, 'Chișinău'),
        (2, 'Hîncești'),
        (3, 'Bălți'),
        (4, 'Cahul'),
        (5, 'Orhei'),
        (6, 'Comrat')
    ''');

      await txn.execute('''
  INSERT INTO ${ZoneFields.zoneTable} (
    ${ZoneFields.idColumn}, 
    ${ZoneFields.nameColumn},
    ${ZoneFields.tarifColumn}, 
    ${ZoneFields.maxParkingColumn}, 
    ${ZoneFields.cityIdColumn}
  )
  VALUES
    (1, 'Centru', 12.0, 3, 1),
    (2, 'Botanica', 10.0, 3, 1),
    (3, 'Râșcanovca', 11.0, 2, 1),
    (4, 'Buiucani', 10.0, 4, 1),
    (5, 'Telecentru', 10.0, 6, 1),
    (6, 'Ciocana', 10.0, 4, 1)
''');
    });
  }

  Future<List<City>> getAllAvailableCitiesWithZones() async {
    final db = await database;

    // Obține toate orașele
    final List<Map<String, dynamic>> cityData =
        await db.query(CityFields.cityTable, orderBy: "id");

    // Pentru fiecare oraș, obține zonele corespunzătoare
    final List<City> cities = await Future.wait(
      cityData.map((cityMap) async {
        final City city = City.fromJson(cityMap);

        // Obține zonele pentru orașul curent
        return db
            .query(
          ZoneFields.zoneTable,
          where: '${ZoneFields.cityIdColumn} = ?',
          whereArgs: [city.id],
          orderBy: "id",
        )
            .then((zoneData) {
          // Creează o copie a orașului cu lista zones actualizată
          final updatedCity = city.copyWith(
            zones: List.generate(zoneData.length, (zoneIndex) {
              return Zones.fromJson(zoneData[zoneIndex]);
            }),
          );

          return updatedCity;
        });
      }),
    );

    return cities;
  }

  // Future<int> addCity(City city) async {
  //   final db = await database;
  //   return db.transaction((txn) async => await txn.insert(
  //         DBKeys.citiesTable,
  //         {CitiesKeys.name: city.city},
  //         conflictAlgorithm: ConflictAlgorithm.replace,
  //       ));
  // }

  // Future<int> removeCity(City cityModel) async {
  //   final db = await database;
  //   return db.transaction((txn) async => await txn.delete(
  //         CityFields.cityTable,
  //         where: 'id = ?',
  //         whereArgs: [cityModel.id],
  //       ));
  // }

  // Future<List<City>> getAllAvailableCities() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> data =
  //       await db.query(CityFields.cityTable, orderBy: "id");
  //   return List.generate(data.length, (index) => City.fromJson(data[index]));
  // }

  Future<City?> getCity(String city) async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(CityFields.cityTable,
        where: '${CityFields.nameColumn} = ?', whereArgs: [city]);
    print('===========================$data');
    if (data.isNotEmpty) {
      return City.fromMap(data.first);
    }
    return null;
  }

  /// ========================================================================>
  ///                                 License Plate
  /// ========================================================================>

  Future<int> addLicensePlate(LicensePlate licensePlate) async {
    final db = await database;

    db.transaction((txn) async => await txn.update(
        LicensePlateFields.licensePlateTable,
        {LicensePlateFields.statusColumn: 0},
        conflictAlgorithm: ConflictAlgorithm.replace));

    return db.transaction((txn) async => await txn.insert(
          LicensePlateFields.licensePlateTable,
          licensePlate.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));
  }

  Future<int> updateStatusLicensePlate(LicensePlate licensePlate) async {
    final db = await database;
    db.transaction((txn) async => await txn.update(
        LicensePlateFields.licensePlateTable,
        {LicensePlateFields.statusColumn: 0},
        conflictAlgorithm: ConflictAlgorithm.replace));

    db.transaction(
      (txn) async => await txn.update(
        LicensePlateFields.licensePlateTable,
        licensePlate.toMap(),
        where: 'id = ?',
        whereArgs: [licensePlate.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
    return 1;
  }

  Future<int> removeLicensePlate(LicensePlate licensePlate) async {
    final db = await database;
    return db.transaction((txn) async => await txn.delete(
          LicensePlateFields.licensePlateTable,
          where: 'id = ?',
          whereArgs: [licensePlate.id],
        ));
  }

  Future<List<LicensePlate>> getAllLicensesPlates() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db
        .query(LicensePlateFields.licensePlateTable, orderBy: "id DESC");
    return List.generate(
        data.length, (index) => LicensePlate.fromJson(data[index]));
  }

  Future<LicensePlate?> getSelectedLicensePlate() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        LicensePlateFields.licensePlateTable,
        where: '${LicensePlateFields.statusColumn} = ?',
        whereArgs: ['1']);
    if (maps.isNotEmpty) {
      return LicensePlate.fromMap(maps.last);
    }
    return null;
  }

  ///========================================================================>
  ///                             zones
  // /// =======================================================================>

  Future<List<Zones>> getZones(City? city) async {
    final db = await database;

    // final City? city = await getCity(cityName);
    if (city != null) {
      final List<Map<String, dynamic>> zones = await db.query(
        ZoneFields.zoneTable,
        where: '${ZoneFields.cityIdColumn} = ?',
        whereArgs: [city.id],
        orderBy: "id",
      );
      if (zones.isNotEmpty) {
        return List.generate(
            zones.length, (index) => Zones.fromJson(zones[index]));
      }
    }
    return [];
  }

  Future<void> closeDb() async {
    return await _database?.close();
  }
}
