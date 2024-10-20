import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignUser extends StatefulWidget {
  Turma? turma;
  AssignUser({super.key, required this.turma});

  @override
  State<AssignUser> createState() => _AssignUserState();
}

class _AssignUserState extends State<AssignUser> {
  bool _isLoading = false;
  AppUser? _selectedUser;
  List<AppUser> _users = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    CollectionReference collection = _firestore.collection('users');

    QuerySnapshot snapshot = await collection.get();
    List<AppUser> fetchedUsers = snapshot.docs.map((doc) {
      return AppUser.fromFirestore(doc);
    }).toList();

    setState(() {
      _users = fetchedUsers;
    });
  }

  Future<void> _assignUser() async {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Selecione um aluno')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('userTurma').add({
        'userId': _selectedUser!.id,
        'turmaId': widget.turma!.id,
        'funcao': 'Representante',
        'ativo': true
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aluno atribuído com sucesso!')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atribuir usuário')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            DropdownButtonFormField<AppUser>(
              hint: Text('Selecione um usuário',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              value: _selectedUser,
              items: _users.map((AppUser user) {
                return DropdownMenuItem<AppUser>(
                  value: user,
                  child: Text(user.nome,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                      )),
                );
              }).toList(),
              onChanged: (AppUser? newValue) {
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
            const SizedBox(height: 40),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1937FE),
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(315, 71)),
                onPressed: _isLoading ? null : _assignUser,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Atribuir usuário',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: const Color(0xFFFFFFFF))),
                          const SizedBox(width: 22),
                          const Icon(Icons.check, color: Color(0xFF1937FE)),
                        ],
                      )),
          ],
        ));
  }
}
