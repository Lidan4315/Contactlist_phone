# contactlist_phone

Aplikasi sederhana untuk menambahkan kontak HP seseorang juga mengedit dan menghapusnya.

Referensi:
- youtube : https://www.youtube.com/watch?v=drk6d2WilLo&t=391s
- github : https://github.com/jatinderji/contacts_list_app

## Perubahan

1. Menambahkan animasi dari lottie saat tidak ada kontak
2. Membuat halaman berbeda untuk menambahkan kontak hp
3. Memperbaiki UI agar terlihat lebih baik
4. Ada perubahan logika pada bagian editnya

## Tampilan Aplikasi

<div align="center">
<table>
  <tr align="center">
    <td><b>Empty Page</b></td>
    <td><b>List Page</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/d267e43f-d00b-4cef-8fb9-ed1f7983971b" alt="Empty Page" width="250"></td>
    <td><img src="https://github.com/user-attachments/assets/4bbcc2fe-9a61-48ec-af52-82c8df56488b" alt="List Page" width="250"></td>
  </tr>
  <tr align="center">
    <td><b>Add Page</b></td>
    <td><b>Edit Page</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/fac02598-7398-4bab-898e-9bed47d7437d" alt="Add Page" width="250"></td>
    <td><img src="https://github.com/user-attachments/assets/be26c533-3c2a-4ab0-93de-c1f9d55a730c" alt="Edit Page" width="250"></td>
  </tr>
</table>
</div>

## Video Demo
[![Tonton Video](https://img.youtube.com/vi/UGM3rnnLG1A/maxresdefault.jpg)](https://www.youtube.com/watch?v=UGM3rnnLG1A)

# Tugas 2 (contactlist_phone using Sqflite)

## Langkah-Langkah
- Run `flutter pub add sqflite`
- Periksa `pubspec.yaml` jika sudah ada bagian seperti dibawah ini berarti instalasi sqlite sudah berhasil:
  ````
  dependencies:
  sqflite:
  ````

## Penjelasan Kode
### DB Helper
Jadi saya membuat kelas spesial bernama DBHelper untuk memmudahkan kita melakukan perubahan di databasenya seperti menambahkan, mengubah, dan mengahpus kontak.Untuk melakukan perubahan tersebut kita menggunakan `dbClient.<nama_fungsi>`. Berikut adalah penjelasan lebih detailnya:
````
static final DBHelper _instance = DBHelper._internal();
factory DBHelper() => _instance;
DBHelper._internal();
````
Agar database tidak dibuka terus menerus, cukup sekali saja.

````
static Database? _db;
````
Tempat untuk penyimpanan databasenya dimana awalnya kosong (null).

````
Future<Database> get db async {
  if (_db != null) return _db!;
  _db = await initDB();
  return _db!;
}
````
Untuk langsung memakai database ketika dibuka dan jika tidak dipakai maka akan `init` dahulu.

````
Future<Database> initDB() async {
  final path = join(await getDatabasesPath(), 'contacts.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE contacts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          contact TEXT NOT NULL
        )
      ''');
    },
  );
}
````
Membuat database jika belum ada, buat file contacts.db, dan buat database yang sesuai.

````
Future<int> insertContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient.insert('contacts', contact.toMap());
  }
````
Untuk menambahkan kontak baru ke dalam tabel contacts dengan data diubah dulu jadi bentuk Map.

````
  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }
````
Ambil semua baris dari tabel contacts.

````
  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }
````
Temukan baris dengan id yang cocok, lalu ganti isinya sesuai data baru.

````
  Future<int> deleteContact(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
````
Temukan kontak dengan id yang cocok lalu hapus dari database.

````
  Future<bool> contactExists(String name, String number) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'contacts',
      where: 'name = ? OR contact = ?',
      whereArgs: [name, number],
    );
    return maps.isNotEmpty;
  }
````
Untuk menemukan apakah kontak sudah pernah disimpan atau belum

### Contact.dart
Berisi class Contact untuk menyimpan satu kontak dalam bentuk "kotak data"

````
Map<String, dynamic> toMap() {
  var map = {
    'name': name,
    'contact': contact,
  };
  if (id != null) {
    map['id'] = id;
  }
  return map;
}
````
Database butuh format seperti peta (Map) agar bisa disimpan dan fungsi ini mengubah Contact jadi bentuk yang bisa disimpan ke SQLite.

````
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
    );
  }
````
Fungsi `fromMap` ini tugasnya untuk mengubah Map  menjadi objek Contact lagi.

### Implementasi DB helper
Contoh mengambil kontak yang sudah di simpan dan ditampilkan di `home_page.dart`.
````
  Future<void> refreshContacts() async {
    final data = await dbHelper.getContacts();
    setState(() {
      contacts = data;
    });
  }
````
Kita tinggal memanggil fungsi yang sudah kita buat di `DB helper` dengan `dbhelper.<nama_fungsi>`.
