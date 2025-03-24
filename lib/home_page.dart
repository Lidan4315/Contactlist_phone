import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'contact.dart';
import 'add_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];

  void navigateToAddContact() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactPage()),
    );

    if (newContact != null) {
      setState(() {
        contacts.add(newContact);
      });
    }
  }

  void editContact(int index) async {
    final editedContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactPage(contact: contacts[index]),
      ),
    );

    if (editedContact != null) {
      setState(() {
        contacts[index] = editedContact;
      });
    }
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
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
          ? Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'asset/animation/no_data.json',
                width: 400,
                repeat: true,
              ),
              const SizedBox(height: 10),
              const Text(
                'No Contacts yet...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: index % 2 == 0 ? Colors.purple : Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                child: Text(
                  contacts[index].name[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                contacts[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(contacts[index].contact),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => editContact(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteContact(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddContact,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
