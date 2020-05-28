import 'package:bytebank_sqflite/components/progress.dart';
import 'package:bytebank_sqflite/database/dao/contact_dao.dart';
import 'package:bytebank_sqflite/models/contact.dart';
import 'package:bytebank_sqflite/screens/contact_form.dart';
import 'package:bytebank_sqflite/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  final ContactDao _dao = new ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder/*<List<Contact>>*/(
          //initialData: List(),
          future: _dao.findAll(),
          //Future.delayed(Duration(seconds: 1)).then((value) => findAll()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Progress();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                final List<Contact> contacts = snapshot.data;
                return ListView.builder(
                    itemBuilder: (context, index) {
                      final Contact contact = contacts[index];
                      return _ContactItem(
                        contact,
                        onClick: () {
                          print('veio aqui');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TransactionForm(contact),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: contacts.length);
                break;
            }

            return Text('Unknow error');
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactForm()),
          ); //.then((newContact) => debugPrint(newContact.toString()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
