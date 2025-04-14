import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'contact.dart';
import 'add_contact_page.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  Future<void> refreshContacts() async {
    final data = await dbHelper.getContacts();
    setState(() {
      contacts = data;
    });
  }

  Future<void> deleteContact(int id) async {
    await dbHelper.deleteContact(id);
    refreshContacts();
  }

  Future<void> navigateToAddPage({Contact? contact}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddContactPage(contact: contact),
      ),
    );

    if (result is Contact) {
      if (contact == null) {
        // Insert
        await dbHelper.insertContact(result);
      } else {
        // Update
        result.id = contact.id;
        await dbHelper.updateContact(result);
      }
      refreshContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: contacts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Lottie.asset(
          'asset/animation/no_data.json',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        const Text(
          'No contacts yet...',
          style: TextStyle(fontSize: 24),
        ),
       ],
      ),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) => getRow(index),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => navigateToAddPage(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0
              ? Colors.deepPurpleAccent
              : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contacts[index].name[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contacts[index].contact),
          ],
        ),
        trailing: SizedBox(
          width: 90,
          child: Row(
            children: [
              InkWell(
                onTap: () => navigateToAddPage(contact: contacts[index]),
                child: const Icon(Icons.edit, color: Colors.blue),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => deleteContact(contacts[index].id!),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
