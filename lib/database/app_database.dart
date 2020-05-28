import 'package:bytebank_sqflite/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// lesson 5.2 async awai
// lesson 5.3 Data Access Object - DAO

Future<Database> getDatabase() async {

  // refact

  //final String dbPath = await getDatabasesPath();
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
      },
      version: 1,
      //onDowngrade: onDatabaseDowngradeDelete,
    );

//  return getDatabasesPath().then((dbPath) {
//    final String path = join(dbPath, 'bytebank.db');
//    return openDatabase(
//      path,
//      onCreate: (db, version) {
//        db.execute('CREATE TABLE contacts ( '
//            'id INTEGER PRIMARY KEY, '
//            'name TEXT, '
//            'account_number INTEGER)');
//      },
//      version: 1,
//      //onDowngrade: onDatabaseDowngradeDelete,
//    );
//  });

}

// ######## refact - two methods below moved to contact_dao.dart ########

//Future<int> save(Contact contact) async {
//
//  // refact
//  final Database db = await getDatabase();
//  final Map<String, dynamic> contactMap = Map();
//  //contactMap['id'] = contact.id; // without this <<, flutter generate id on insert
//  contactMap['name'] = contact.name;
//  contactMap['account_number'] = contact.accountNumber;
//  return db.insert('contacts', contactMap);
//
////  return getDatabase().then((db) {
////    final Map<String, dynamic> contactMap = Map();
////    contactMap['name'] = contact.name;
////    contactMap['account_number'] = contact.accountNumber;
////    return db.insert('contacts', contactMap);
////  });
//}
//
//Future<List<Contact>> findAll() async {
//
//  // refact
//
//  final Database db = await getDatabase();
//  final List<Map<String, dynamic>> resultados = await db.query('contacts');
//  final List<Contact> contacts = List();
//
//  for (Map<String, dynamic> row in resultados) {
//    final Contact contact = new Contact(
//      row['id'],
//      row['name'],
//      row['account_number'],
//    );
//    contacts.add(contact);
//  }
//
//  return contacts;
//
////  return getDatabase().then((db) {
////    return db.query('contacts').then((maps) {
////      final List<Contact> contacts = List();
////
////      for (Map<String, dynamic> row in maps) {
////        final Contact contact = new Contact(
////          row['id'],
////          row['name'],
////          row['account_number'],
////        );
////        contacts.add(contact);
////      }
////
////      return contacts;
////    });
////  });
//
//}

