import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  ///Singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  ///table note
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO = "s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESCRI = "description";

  Database? myBD;

  /// db Open (path -> if exist then open else create db )
  Future<Database> getDB() async {
    myBD ??= await openDB();
    return myBD!;

    /*if(myBD != null){
        return myBD!;
      }else{
        myBD = await openDB();
        return myBD!;
      }*/
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        ///Create all your Tables here
        db.execute(
          "create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESCRI text )",
        );

        ///N no of tables can be created here with unique Table name
        ///
        ///
        ///
      },
      version: 1,
    );
  }

  ///all queries
  ///insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESCRI: mDesc,
    });
    return rowsEffected > 0;
  }

  ///READING ALL DATA
  Future<List<Map<String, dynamic>>> getALLNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);

    return mData;
  }

  ///Update data
  Future<bool> updateNote({
    required String mTitle,
    required String mDescri,
    required int sno,
  }) async {
    var db = await getDB();

    int rowsEfffeect = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESCRI: mDescri,
    }, where: "$COLUMN_NOTE_SNO = $sno");
    return rowsEfffeect > 0;
  }

  ///Delete note
  Future<bool> deleteNote({required int sno}) async {
    var db = await getDB();

    int rowsEffect = await db.delete(
      TABLE_NOTE,
      where: "$COLUMN_NOTE_SNO = ?",
      whereArgs: ['$sno'],
    );

    return rowsEffect > 0;
  }
}
