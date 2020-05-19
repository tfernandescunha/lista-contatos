import 'package:agendacontatos/models/contact.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTableName = 'contactTable';

class ContactHelper {
  static final ContactHelper _instace = ContactHelper.internal();

  factory ContactHelper() => _instace;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (this._db != null)
      return this._db;
    else {
      this._db = await initDb();
      return this._db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "mycontacts.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $contactTableName(idColumn INTEGER PRIMARY KEY, "
          "nameColumn "
          "TEXT, emailColumn TEXT, phoneColumn TEXT, imgColumn TEXT)");
    });
  }

  Future<ContactModel> saveContact(ContactModel contactModel) async {
    Database dbContact = await this.db;
    contactModel.id = await dbContact.insert(contactTableName, contactModel.toMap());

    return contactModel;
  }

  Future<ContactModel> getContact(int id) async {
    Database dbContact = await this.db;

    List<Map> maps = await dbContact.query(contactTableName,
        columns: ["idColumn", "nameColumn", "emailColumn", "phoneColumn", "imgColumn"],
        where: "idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return ContactModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await this.db;

    return await dbContact.delete(contactTableName, where: "idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(ContactModel contact) async {
    Database dbContact = await this.db;

    return await dbContact
        .update(contactTableName, contact.toMap(), where: "idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List<ContactModel>> getAllContacts() async {
    Database dbContact = await this.db;

    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTableName");

    List<ContactModel> listContact = List();

    listMap.forEach((element) {
      listContact.add(ContactModel.fromMap(element));
    });

    return listContact;
  }

  Future<int> getTotalContacts() async {
    Database dbContact = await this.db;

    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM "
        "$contactTableName"));
  }

  Future<void> close() async {
    Database dbContact = await this.db;

    dbContact.close();
  }
}
