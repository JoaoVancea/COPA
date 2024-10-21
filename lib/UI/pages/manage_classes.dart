import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/UI/pages/assign_user.dart';
import 'package:copa/UI/pages/create_class.dart';
import 'package:copa/UI/pages/edit_class.dart';
import 'package:copa/UI/pages/edit_user_turma.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageClasses extends StatefulWidget {
  const ManageClasses({super.key});

  @override
  State<ManageClasses> createState() => _ManageClassesState();
}

class _ManageClassesState extends State<ManageClasses> {
  Turma? _selectedClass;
  List<Turma> _classes = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    CollectionReference collection = _firestore.collection('turmas');

    QuerySnapshot snapshot = await collection.get();
    List<Turma> fetchedClasses = snapshot.docs.map((doc) {
      return Turma.fromFirestore(doc);
    }).toList();

    setState(() {
      _classes = fetchedClasses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                color: Color(0xFF4960F9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                        child: SvgPicture.asset('logoCopa.svg'),
                      ),
                      Image.asset('luko.png')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Gerenciar Turmas',
                      style: GoogleFonts.montserrat(
                          fontSize: 24, color: Colors.white)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              side: const BorderSide(
                                  color: Colors.white, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              minimumSize: const Size(151, 56)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CreateClass()));
                          },
                          child: Text(
                            'Criar Turma',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.white),
                          )),
                      const SizedBox(width: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              side: const BorderSide(
                                  color: Colors.white, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              minimumSize: const Size(151, 56)),
                          onPressed: () {
                            if (_selectedClass != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditClass(
                                          turma: _selectedClass as Turma)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Selecione uma turma')));
                            }
                          },
                          child: Text(
                            'Editar Turma',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 280, 20, 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFFDFDFDF),
                      borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonFormField<Turma>(
                            hint: Text('Selecione uma turma',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            value: _selectedClass,
                            items: _classes.map((Turma turma) {
                              return DropdownMenuItem<Turma>(
                                value: turma,
                                child: Text(turma.nome,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                    )),
                              );
                            }).toList(),
                            onChanged: (Turma? newValue) {
                              setState(() {
                                _selectedClass = newValue;
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
                          _selectedClass != null
                              ? Column(children: [
                                  const SizedBox(height: 30),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            color: const Color(0xFFF2F4F8))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: InputBorder.none,
                                          hintText: 'Presença',
                                          hintStyle: GoogleFonts.montserrat(
                                              color: const Color(0xFF979797))),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            color: const Color(0xFFF2F4F8))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: InputBorder.none,
                                          hintText: 'Evento',
                                          hintStyle: GoogleFonts.montserrat(
                                              color: const Color(0xFF979797))),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF4960F9),
                                          Color(0xFF1433FF)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Atribuir Pontos',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            const Icon(Icons.chevron_right,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ])
                              : const SizedBox.shrink()
                        ]),
                  ),
                ),
                _selectedClass != null
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          Column(
                            //Representantes column
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF2B47FC),
                                            width: 1))),
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Representantes',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssignUser(
                                                          turma:
                                                              _selectedClass)));
                                        },
                                        child: Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF2743FD),
                                                  width: 2),
                                              color: Colors.transparent),
                                          child: const Icon(
                                            Icons.add,
                                            color: Color(0xFF2743FD),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                            stream: _firestore
                                .collection('userTurma')
                                .where('turmaId', isEqualTo: _selectedClass!.id)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text('Nenhum aluno atribuído');
                              }

                              return ListView.builder(
                                shrinkWrap:
                                    true, // Permite que o ListView se ajuste ao conteúdo
                                physics:
                                    const NeverScrollableScrollPhysics(), // Evita rolagem dentro de rolagem
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  //Obter o documento no índice atual
                                  var userDocument = snapshot.data!.docs[index];

                                  //Extrair os dados do documento
                                  var userId = userDocument['userId'];
                                  var userTurmaId = userDocument.id;

                                  return FutureBuilder(
                                    future: _firestore
                                        .collection('users')
                                        .doc(userId)
                                        .get(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const ListTile(
                                          title: Text('Carregando...'),
                                        );
                                      }

                                      if (!userSnapshot.hasData ||
                                          !userSnapshot.data!.exists) {
                                        return const ListTile(
                                          title: Text('Usuário não encontrado'),
                                        );
                                      }

                                      var userData = userSnapshot.data!.data()
                                          as Map<String, dynamic>;
                                      var userName = userData['nome'];
                                      var userImg = userData['imgUser'];
                                      var ativo = userDocument['ativo'];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(userImg),
                                                  radius: 24,
                                                ),
                                                const SizedBox(width: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(userName,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    Row(
                                                      children: [
                                                        // Indicador de status ativo/inativo com ponto colorido
                                                        Icon(Icons.circle,
                                                            size: 12,
                                                            color: ativo
                                                                ? const Color(
                                                                    0xFF6FFD84)
                                                                : const Color(
                                                                    0xFFFF6262)),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          ativo
                                                              ? 'Ativo'
                                                              : 'Inativo',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: ativo
                                                                  ? const Color(
                                                                      0xFF6FFD84)
                                                                  : const Color(
                                                                      0xFFFF6262)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.grey),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditUserTurma(
                                                              userId: userId,
                                                              userTurmaId:
                                                                  userTurmaId,
                                                            )));
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Column(
                            //Ocorrências column
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF2B47FC),
                                            width: 1))),
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Ocorrências',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          )
        ])
      ]),
    );
  }
}
