import 'package:bytebank_sqflite/components/response_dialog.dart';
import 'package:bytebank_sqflite/components/transaction_auth_dialog.dart';
import 'package:bytebank_sqflite/http/webclients/transaction_webclient.dart';
import 'package:bytebank_sqflite/models/contact.dart';
import 'package:bytebank_sqflite/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebCliente _webCliente = new TransactionWebCliente();

  @override
  Widget build(BuildContext context) {
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
                          Transaction(value, widget.contact);

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
    final Transaction transactionReceived = await _webCliente.save(transactionCreated, password).catchError((e) {
      showDialog(context: context, builder: (contextDialog) {
        return FailureDialog(e.message);
      },);
    }, test: (e) => e is Exception);

    if (transactionReceived != null) {
      await showDialog(context: context, builder: (contextDialog) {
        return SuccessDialog('successful transaction');
      });
      Navigator.of(context).pop();
    }
  }

}
