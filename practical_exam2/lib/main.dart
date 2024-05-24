import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(ContactApp());
}

class Contact {
  final String name;
  final String phoneNumber;
  final String email;
  final String address;

  Contact({required this.name, required this.phoneNumber, required this.email, required this.address});
}

class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    contacts = _loadContacts();
  }

  List<Contact> _loadContacts() {
    // Simulating loading contacts from a directory
    // Replace this with your actual implementation
    return [];
  }

  void addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void editContact(int index, Contact editedContact) {
    setState(() {
      contacts[index] = editedContact;
    });
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
        title: Text('Contacts'),
      ),
      body: ContactList(contacts: contacts, onEdit: editContact, onDelete: deleteContact),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen(addContact: addContact)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ContactList extends StatelessWidget {
  final List<Contact> contacts;
  final Function(int, Contact) onEdit;
  final Function(int) onDelete;

  ContactList({required this.contacts, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Center(
        child: Text('No contacts found.'),
      );
    } else {
      contacts.sort((a, b) => a.name.compareTo(b.name));
      return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                contact.name.substring(0, 1),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddContactScreen(
                  addContact: (editedContact) {
                    onEdit(index, editedContact);
                  },
                  contact: contact,
                )),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Contact'),
                      content: Text('Are you sure you want to delete this contact?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(index);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    }
  }
}

class AddContactScreen extends StatefulWidget {
  final Function(Contact) addContact;
  final Contact? contact;

  AddContactScreen({required this.addContact, this.contact});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneNumberController.text = widget.contact!.phoneNumber;
      _emailController.text = widget.contact!.email;
      _addressController.text = widget.contact!.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact != null ? 'Edit Contact' : 'Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveContact();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    final String name = _nameController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();
    final String email = _emailController.text.trim();
    final String address = _addressController.text.trim();

    Contact editedContact = Contact(name: name, phoneNumber: phoneNumber, email: email, address: address);

    widget.addContact(editedContact);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
