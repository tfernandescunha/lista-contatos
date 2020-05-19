import 'package:agendacontatos/helpers/contact.helper.dart';
import 'package:agendacontatos/models/contact.model.dart';
import 'package:agendacontatos/ui/roundes_contact_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final ContactModel contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactModel _editedContact;
  bool _userEdited = false;
  ContactHelper helper = ContactHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: this._requestPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: true,
            title: Text(this._editedContact.name ?? 'Novo Contato'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (this._editedContact.name != null && this._editedContact.name.isNotEmpty) {
                Navigator.pop(context, this._editedContact);
              } else {
                FocusScope.of(context).requestFocus(this._nameFocus);
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: Icon(Icons.save),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    child: ContactImage(_editedContact.img, 140.0, 140.0),
                    onTap: () {
                      ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                        if (file == null) {
                          return;
                        } else {
                          setState(() {
                            this._editedContact.img = file.path;
                          });
                        }
                      });
                    }),
                TextField(
                  controller: this._nameController,
                  focusNode: this._nameFocus,
                  decoration: InputDecoration(labelText: 'Nome'),
                  onChanged: (String text) {
                    this._userEdited = true;
                    setState(() {
                      this._editedContact.name =
                          text.isEmpty || text == null ? 'Novo Contato' : text;
                    });
                  },
                ),
                TextField(
                  controller: this._emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (String text) {
                    this._userEdited = true;
                    this._editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: this._phoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                  onChanged: (String text) {
                    this._userEdited = true;
                    this._editedContact.phoneNumber = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      this._editedContact = ContactModel();
    } else {
      this._editedContact = ContactModel.fromMap(widget.contact.toMap());
      this._setForm();
    }
  }

  void _setForm() {
    setState(() {
      this._nameController.text = this._editedContact.name;
      this._emailController.text = this._editedContact.email;
      this._phoneController.text = this._editedContact.phoneNumber;
    });
  }

  Future<bool> _requestPop() {
    if (this._userEdited) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Descartar Alterações?'),
              content: Text('se sair as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showOption(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[

              ],
            ),
          );
        }
      );
    });
  }
}
