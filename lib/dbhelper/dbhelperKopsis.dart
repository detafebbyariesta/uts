import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/itemKopsis.dart';

class DbHelperKopsis {
  static DbHelperKopsis _dbHelperKopsis;
  static Database _database;
  DbHelperKopsis._createObject();
  Future<Database> initDb() async {
//untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'itemKopsis.db';
//create, read databases
    var itemKopsisDatabase = openDatabase(path,
        version: 8,
        onCreate: _createDb,
        onUpgrade:
            _onUpgrade); //mengembalikan nilai object sebagai hasil dari fungsinya
    return itemKopsisDatabase;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _createDb(db, newVersion);
  }

//buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    var batch = db.batch();
    await batch.execute('DROP TABLE IF EXISTS item');
    await batch.execute('''
    
    CREATE TABLE itemKopsis (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    namaKopsis TEXT,
    tanggal TEXT
    )
    ''');
    await batch.commit();
  }

//select databases
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('itemKopsis', orderBy: 'namaKopsis');
    return mapList;
  }

//create databases
  Future<int> insert(ItemKopsis object) async {
    Database db = await this.initDb();
    int count = await db.insert('itemKopsis', object.toMap());
    return count;
  }

//update databases
  Future<int> update(ItemKopsis object) async {
    Database db = await this.initDb();
    int count = await db.update('itemKopsis', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //delete databases
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('itemKopsis', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<ItemKopsis>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    List<ItemKopsis> itemList = List<ItemKopsis>();
    for (int i = 0; i < count; i++) {
      itemList.add(ItemKopsis.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  factory DbHelperKopsis() {
    if (_dbHelperKopsis == null) {
      _dbHelperKopsis = DbHelperKopsis._createObject();
    }
    return _dbHelperKopsis;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<ItemKopsis>> getItemKopsisList() {}
}
