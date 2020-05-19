import 'package:agendacontatos/helpers/contact.helper.dart';
import 'package:agendacontatos/models/contact.model.dart';
import 'package:agendacontatos/ui/contact_page.dart';
import 'package:agendacontatos/ui/roundes_contact_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<ContactModel> contacts = List();

  @override
  void initState() {
    super.initState();
    this._loadAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text('Order de A-Z'),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text('Order de A-A'),
                  value: OrderOptions.orderza,
                ),
              ];
            },
            onSelected: this._orderContactList,
          )
        ],
        title: Text("Lista de Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          this._showContactPage();
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return this._contactCard(context, this.contacts[index]);
        },
        itemCount: this.contacts.length,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  Widget _contactCard(BuildContext context, ContactModel contact) {
    return GestureDetector(
      onTap: () => this._showOptions(context, contact),
      onLongPress: () {},
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              ContactImage(contact.img, 80.0, 80.0),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contact.name ?? '',
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email ?? '',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(contact.phoneNumber ?? '',
                        style: TextStyle(
                          fontSize: 18.0,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, ContactModel contact) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          launch("tel:${contact.phoneNumber}");
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Ligar',
                          style: TextStyle(color: Colors.green, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          this._showContactPage(contact: contact);
                        },
                        child: Text(
                          'Editar',
                          style: TextStyle(color: Colors.blue, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          this.helper.deleteContact(contact.id);
                          setState(() {
                            this.contacts.remove(contact);
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({ContactModel contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ContactPage(
                  contact: contact,
                )));

    if (recContact != null) {
      if (contact != null) {
        await this.helper.updateContact(recContact);
      } else {
        await this.helper.saveContact(recContact);
      }

      this._loadAllContacts();
    }
  }

  void _loadAllContacts() {
    helper.getAllContacts().then((contactsList) {
      setState(() {
        this.contacts = contactsList;
      });
    });
  }

  void _orderContactList(OrderOptions result) {
    setState(() {
      this.contacts.sort((a, b) {
        return (result == OrderOptions.orderaz)
            ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
            : b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });
    });
  }
}
