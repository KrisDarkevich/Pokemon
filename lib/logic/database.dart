import 'package:pokemons/logic/api/models/one_pokemon.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PokeDatabase {
  static final PokeDatabase instance = PokeDatabase._init();
  static Database? _database;
  static const String dbName = 'pokemons';

  PokeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('$dbName.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    await db.execute(
        '''CREATE TABLE pokemons(id $idType, name $textType, url $textType)''');
  }

  Future<int> create(OnePokemon pokemon) async {
    final db = await instance.database;
    return await db.insert(dbName, pokemon.toMap());
  }

  Future<List<OnePokemon>> getPokemonList() async {
    final db = await instance.database;
    final result = await db.query(dbName);

    return result
        .map(
          (json) => OnePokemon(json['name'] as String, json['url'] as String),
        )
        .toList();
  }

  Future<OnePokemon?> getPokemonByName(String name) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      dbName,
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return OnePokemon.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> insertPokemon(OnePokemon pokemon) async {
    final db = await instance.database;
    await db.insert(
      dbName,
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<OnePokemon>> getAllPokemons() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(dbName);

    return maps.map((map) => OnePokemon.fromJson(map)).toList();
  }

  Future<List<OnePokemon>> getPokemons(int offset, int limit) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      dbName,
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => OnePokemon.fromJson(map)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
