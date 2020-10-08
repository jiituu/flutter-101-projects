import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treasure_mapp/place.dart';

class DbHelper {
  final int version = 1;
  Database db;
  List<Place> places = List<Place>();


  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'mapp.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, lon DOUBLE, image TEXT)');
      }, version: version);
    }

    return db;
  }

  Future insertMockData() async {
    db = await openDb();
    await db.execute(
        'INSERT INTO places VALUES (1, "Scuba", 40.176317, 23.715589, "")');
    await db.execute(
        'INSERT INTO places VALUES (2, "Krisi", 42.148496, 24.733752, "")');
    await db.execute(
        'INSERT INTO places VALUES (3, "Veleka", 42.068401, 27.970427, "")');
    List places = await db.rawQuery('select * from places');
    print(places[0].toString());
  }

  Future<List<Place>> getPlaces() async {
    final List<Map<String, dynamic>> maps = await db.query('places');
    // Convert the List<Map<String, dynamic> into a List<Places>.
    this.places = List.generate(maps.length, (i) {
      return Place(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['lat'],
        maps[i]['lon'],
        maps[i]['image'],
      );
    });
    return places;
  }

  Future<int> insertPlace(Place place) async {
    // Get a reference to the database.

    int id = await this.db.insert(
      'places',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deletePlace(Place place) async {
    int result = await db.delete("places", where: "id = ?", whereArgs: [place.id]);
    return result;
  }
}
