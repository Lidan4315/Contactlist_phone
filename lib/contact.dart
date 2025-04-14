class Contact {
  int? id; // id bisa null saat pertama dibuat
  String name;
  String contact;

  Contact({this.id, required this.name, required this.contact});

  // Konversi ke Map untuk disimpan ke database
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'contact': contact,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Konversi dari Map hasil ambil dari database
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
    );
  }
}
