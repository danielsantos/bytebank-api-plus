import 'package:bytebank_sqflite/database/app_database.dart';
import 'package:bytebank_sqflite/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {

  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  static const String tableSql = 'CREATE TABLE $_tableName ( '
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  Future<int> save(Contact contact) async {

    // refact
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);

//  return getDatabase().then((db) {
//    final Map<String, dynamic> contactMap = Map();
//    contactMap['name'] = contact.name;
//    contactMap['account_number'] = contact.accountNumber;
//    return db.insert('contacts', contactMap);
//  });
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    //contactMap['id'] = contact.id; // without this <<, flutter generate id on insert
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {

    // refact

    final Database db = await getDatabase();
    final List<Map<String, dynamic>> resultados = await db.query(_tableName);
    List<Contact> contacts = _toList(resultados);
    return contacts;

//  return getDatabase().then((db) {
//    return db.query('contacts').then((maps) {
//      final List<Contact> contacts = List();
//
//      for (Map<String, dynamic> row in maps) {
//        final Contact contact = new Contact(
//          row['id'],
//          row['name'],
//          row['account_number'],
//        );
//        contacts.add(contact);
//      }
//
//      return contacts;
//    });
//  });

  }

  List<Contact> _toList(List<Map<String, dynamic>> resultados) {
    final List<Contact> contacts = List();
    for (Map<String, dynamic> row in resultados) {
      final Contact contact = new Contact(
        row[_id],
        row[_name],
        row[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }

}