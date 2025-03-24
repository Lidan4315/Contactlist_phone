import 'package:flutter/material.dart';
import 'contact.dart';

class AddContactPage extends StatefulWidget {
  final Contact? contact;

  const AddContactPage({super.key, this.contact});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      contactController.text = widget.contact!.contact;
    }
  }

  void saveContact() {
    String name = nameController.text.trim();
    String contact = contactController.text.trim();

    if (name.isEmpty || contact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Contact cannot be empty!')),
      );
      return;
    }

    if (contact.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact number must be at least 10 digits!')),
      );
      return;
    }

    Navigator.pop(context, Contact(name: name, contact: contact));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact'),
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
              child: Text(widget.contact == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
