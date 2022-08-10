
import 'package:blogapp/Search/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'dart:io' as io;


class DBHelper2 {

  static Database _db ;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }

    _db = await initDatabase();
  }

  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory() ;
    String path = join(documentDirectory.path , 'cart1.db');
    var db = await openDatabase(path , version: 1 , onCreate: _onCreate,);
    return db ;
  }

  _onCreate (Database db , int version )async{
    await db.execute('CREATE TABLE cart1 (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<Cart1> insert(Cart1 cart1)async{
    print(cart1.toMap());
    var dbClient = await db ;
    await dbClient.insert('cart1', cart1.toMap());
    return cart1 ;
  }

  Future<List<Cart1>> getCartList()async{
    var dbClient = await db ;
    final List<Map<String , Object>> queryResult =  await dbClient.query('cart1');
    return queryResult.map((e) => Cart1.fromMap(e)).toList();

  }

  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient.delete(
        'cart1',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<int> updateQuantity(Cart1 cart1)async{
    var dbClient = await db ;
    return await dbClient.update(
        'cart1',
        cart1.toMap(),
        where: 'id = ?',
        whereArgs: [cart1.id]
    );
  }
}