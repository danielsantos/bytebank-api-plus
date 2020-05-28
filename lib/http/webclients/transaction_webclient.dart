import 'dart:convert';

import 'package:bytebank_sqflite/http/webclient.dart';
import 'package:bytebank_sqflite/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebCliente {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 5));
    List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    // refact
    //Map<String, dynamic> transactionMap = _toMap(transaction);
    //final String transactionJson = jsonEncode(transactionMap);

    final String transactionJson = jsonEncode(transaction.toJson());
    final Response response = await client.post(
      baseUrl,
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson,
    );

    return Transaction.fromJson(jsonDecode(response.body));
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();

    // refact
    //final List<Transaction> transactions = List();

    //for (Map<String, dynamic> transactionJson in decodedJson) {

    // refact
//      final Map<String, dynamic> contactJson = transactionJson['contact'];
//      final Transaction transaction = Transaction(
//        transactionJson['value'],
//        Contact(
//          0,
//          contactJson['name'],
//          contactJson['accountNumber'],
//        ),
//      );
//
//      transactions.add(transaction);

    //transactions.add(Transaction.fromJson(transactionJson));

    //}
    //return transactions;
  }

// refact
//  Transaction _toTransaction(Response response) {
//    Map<String, dynamic> json = jsonDecode(response.body);

// refact
//    final Map<String, dynamic> contactJson = json['contact'];
//
//    final Transaction transactionCreated = Transaction(
//      json['value'],
//      Contact(
//        0,
//        contactJson['name'],
//        contactJson['accountNumber'],
//      ),
//    );
//
//    return transactionCreated;

//    return Transaction.fromJson(json);
//  }

// refact
//  Map<String, dynamic> _toMap(Transaction transaction) {
//    final Map<String, dynamic> transactionMap = {
//      'value': transaction.value,
//      'contact': {
//        'name': transaction.contact.name,
//        'accountNumber': transaction.contact.accountNumber
//      }
//    };
//    return transactionMap;
//  }

}
