import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignUser extends StatefulWidget {
  const AssignUser({super.key});

  @override
  State<AssignUser> createState() => _AssignUserState();
}

class _AssignUserState extends State<AssignUser> {
  String? _selectedUser;
  List<String> _users = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    CollectionReference collection = _firestore.collection('users');

    QuerySnapshot snapshot = await collection.get();
    List<String> fetchedUsers = snapshot.docs.map((doc) {
      return doc['nome'] as String;
    }).toList();

    setState(() {
      _users = fetchedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DropdownButtonFormField<String>(
        hint: Text('Selecione um usuário',
            style: GoogleFonts.montserrat(
                fontSize: 12, fontWeight: FontWeight.bold)),
        value: _selectedUser,
        items: _users.map((String className) {
          return DropdownMenuItem<String>(
            value: className,
            child: Text(className,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                )),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedUser = newValue;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
