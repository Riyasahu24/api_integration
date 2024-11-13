import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:assignment/model/product_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'product_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE selectedServices (
        id TEXT PRIMARY KEY,
        itemName TEXT,
        price REAL,
        discount REAL,
        quantity INTEGER
      )
    ''');
  }

  Future<void> saveSelectedService(Services service, int quantity) async {
    final db = await database;
    double discount = (double.tryParse(service.price) ?? 0.0) /
        (double.tryParse(service.discount[0].percentage) ?? 0.0);
    double discountedPrice = (double.tryParse(service.price) ?? 0.0) - discount;

    await db.insert(
      'selectedServices',
      {
        'id': service.itemId,
        'itemName': service.itemName,
        'price': double.tryParse(service.price),
        'discount': discountedPrice,
        'quantity': quantity
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getServiceQuantity(String itemId) async {
    final db = await database;
    final result = await db.query(
      'selectedServices',
      columns: ['quantity'],
      where: 'id = ?',
      whereArgs: [itemId],
    );
    if (result.isNotEmpty) {
      return result.first['quantity'] as int;
    }
    return 0;
  }

  Future<void> removeServiceQuantity(String itemId) async {
    final db = await database;
    await db.delete(
      'selectedServices',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<List<Map<String, dynamic>>> getSelectedServices() async {
    final db = await database;
    return await db.query('selectedServices');
  }
}
