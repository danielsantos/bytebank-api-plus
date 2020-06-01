import 'dart:async';

import 'package:bytebank_sqflite/components/response_dialog.dart';
import 'package:bytebank_sqflite/components/transaction_auth_dialog.dart';
import 'package:bytebank_sqflite/http/webclients/transaction_webclient.dart';
import 'package:bytebank_sqflite/models/contact.dart';
import 'package:bytebank_sqflite/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebCliente _webCliente = new TransactionWebCliente();
  final String transactionId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    print('transaction form id $transactionId');
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value, widget.contact);

                      showDialog(
                          context: context,
                          builder: (contextDialog,) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                _save(transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password, BuildContext context) async {
    //await Future.delayed(Duration(seconds: 1)); // just for test
    Transaction transactionReceived = await _send(transactionCreated, password, context);

    _showSuccessfulMessage(transactionReceived, context);
  }

  Future _showSuccessfulMessage(Transaction transactionReceived, BuildContext context) async {
    if (transactionReceived != null) {
      await showDialog(context: context, builder: (contextDialog) {
        return SuccessDialog('successful transaction');
      });
      Navigator.of(context).pop();
    }
  }

  Future<Transaction> _send(Transaction transactionCreated, String password, BuildContext context) async {
    final Transaction transactionReceived = await _webCliente.save(transactionCreated, password)
    .catchError((e) {
      _showFailureMessage(context, message: 'timeout on submitting the transaction');
    }, test: (e) => e is TimeoutException) // FIXME Don't work 'TimeoutException' is not generate
    .catchError((e) {
      _showFailureMessage(context, message: e.message);
    }, test: (e) => e is Exception) // HttpException
    .catchError((e) {
      _showFailureMessage(context);
    });
    return transactionReceived;
  }

  void _showFailureMessage(BuildContext context, {String message = 'Unknow error'}) {
    showDialog(context: context, builder: (contextDialog) {
      return FailureDialog(message);
    },);
  }

}
