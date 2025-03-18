import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'yesbank.db');
  return openDatabase(
    path,
    onCreate: (db, version) async {
      // await db.execute(ClienteDao.tableSql);
      // await db.execute(LocalNotificationDao.tableSql);
    },
    version: 1,
  );
}
