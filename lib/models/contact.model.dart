class ContactModel {
  int id;
  String name;
  String email;
  String phoneNumber;
  String img;

  ContactModel();

  ContactModel.fromMap(Map map) {
  	id = map["idColumn"];
  	name = map["nameColumn"];
  	email = map["emailColumn"];
  	phoneNumber = map["phoneColumn"];
  	img = map["imgColumn"];
  }

  Map toMap() {
  	Map<String, dynamic> mapa = {
  		'nameColumn': this.name,
		'emailColumn': this.email,
		'phoneColumn': this.phoneNumber,
		'imgColumn': this.img
  	};

  	if (this.id != null) {
  		mapa['idColumn'] = this.id;
	}

  	return mapa;
  }

  @override
  String toString() {
	  return 'Contact(id: ${this.id}, name: ${this.name}, email: ${this.email}, phoneNumber: '
		  '$phoneNumber';
  }


}
