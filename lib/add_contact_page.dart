import 'package:flutter/material.dart';
import 'contact.dart';
import 'db_helper.dart';

class AddContactPage extends StatefulWidget {
  final Contact? contact;

  const AddContactPage({super.key, this.contact});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      contactController.text = widget.contact!.contact;
    }
  }

  Future<void> saveContact() async {
    String name = nameController.text.trim();
    String number = contactController.text.trim();

    if (name.isEmpty || number.isEmpty) {
      showSnackbar('Name and number cannot be empty!');
      return;
    }

    if (number.length < 10) {
      showSnackbar('Number must be at least 10 digits!');
      return;
    }

    // Cek duplikat di database
    final allContacts = await dbHelper.getContacts();
    bool isDuplicate = allContacts.any((c) =>
    (c.name.toLowerCase() == name.toLowerCase() ||
        c.contact == number) &&
        c.id != widget.contact?.id);

    if (isDuplicate) {
      showSnackbar('Name or number already exists!');
      return;
    }

    final newContact = Contact(name: name, contact: number);
    Navigator.pop(context, newContact);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'Add Contact'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              maxLength: 12,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveContact,
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
