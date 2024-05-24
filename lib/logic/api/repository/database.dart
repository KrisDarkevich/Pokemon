import 'package:flutter/material.dart';
import 'package:pokemons/logic/api/pokemon_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PokeDatabase {
  static final PokeDatabase instance = PokeDatabase._init();
  static Database? _database;

  PokeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pokemons.db');
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

    await db
        .execute('''CREATE TABLE pokemons(name $textType, url $textType)''');
  }

  Future<int> create(Results pokemon) async {
    final db = await instance.database;
    return await db.insert('pokemons', pokemon.toMap());
  }

  Future<List<Results>> allPokemon() async {
    final db = await instance.database;
    final result = await db.query('pokemons');

    return result
        .map(
          (json) => Results(json['name'] as String, json['url'] as String),
        )
        .toList();
  }

  Future<int> update(Results pokemon) async {
    final db = await instance.database;
    return db.update(
      'pokemons',
      pokemon.toMap(),
      where: 'name = ?',
      whereArgs: [pokemon.name],
    );
  }

  Future<Results?> getPokemonByName(String name) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pokemons',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Results.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> insertPokemon(Results pokemon) async {
    final db = await instance.database;
    await db.insert(
      'pokemons',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Results>> getAllPokemons() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('pokemons');

    return maps.map((map) => Results.fromJson(map)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
