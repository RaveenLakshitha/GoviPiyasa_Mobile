
import 'package:blogapp/wishlist/wish_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'dart:io' as io;


class DBHelper1 {

  static Database _db ;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }

    _db = await initDatabase();
  }

  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory() ;
    String path = join(documentDirectory.path , 'wish.db');
    var db = await openDatabase(path , version: 1 , onCreate: _onCreate,);
    return db ;
  }

  _onCreate (Database db , int version )async{
    await db.execute('CREATE TABLE wish (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<Wish> insert(Wish wish)async{
    print(wish.toMap());
    var dbClient = await db ;
    await dbClient.insert('wish', wish.toMap());
    return wish ;
  }

  Future<List<Wish>> getCartList()async{
    var dbClient = await db ;
    final List<Map<String , Object>> queryResult =  await dbClient.query('wish');
    return queryResult.map((e) => Wish.fromMap(e)).toList();

  }

  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient.delete(
        'wish',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<int> updateQuantity(Wish wish)async{
    var dbClient = await db ;
    return await dbClient.update(
        'wish',
        wish.toMap(),
        where: 'id = ?',
        whereArgs: [wish.id]
    );
  }
}