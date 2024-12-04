import 'package:copa/features/user/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvaliarEventoPage extends StatefulWidget {
  final String eventoId; // O ID do evento que será avaliado
  final AppUser appUser; // Admin que está avaliando
  AvaliarEventoPage({required this.eventoId, required this.appUser});

  @override
  _AvaliarEventoPageState createState() => _AvaliarEventoPageState();
}

class _AvaliarEventoPageState extends State<AvaliarEventoPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _showDocumentField =
      false; // Controla a visibilidade do campo de pontuação
  final TextEditingController _pontuacaoController =
      TextEditingController(text: '10'); // Valor padrão

  Future<void> _aprovarEvento() async {
    await _firestore.collection('evento').doc(widget.eventoId).update({
      'valor': int.parse(_pontuacaoController
          .text), // Usa a pontuação fornecida ou a padrão (10)
    });
    Navigator.pop(context); // Volta à tela anterior após a aprovação
  }

  Future<void> _negarEvento() async {
    await _firestore.collection('evento').doc(widget.eventoId).update({
      'valor': -1, // Marca o evento como negado
    });
    Navigator.pop(context); // Volta à tela anterior após a negação
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Evento'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('evento').doc(widget.eventoId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final evento = snapshot.data!.data() as Map<String, dynamic>;
          final String titulo = evento['titulo'];
          final String descricao = evento['descricao'];
          final String userId =
              evento['user']; // ID do usuário que criou o evento
          final String turmaId = evento['turmaId']; // ID da turma associada
          final String imageUrl = evento['imageUrl']; // URL da imagem do evento

          return FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('turmas').doc(turmaId).get(),
            builder: (context, turmaSnapshot) {
              if (!turmaSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final turma = turmaSnapshot.data!.data() as Map<String, dynamic>;
              final String turmaNome = turma['turma']; // Nome da turma

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final String userNome = user['nome'];
                  final String userFoto = user['imgUser'];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(userFoto),
                              radius: 25,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userNome,
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  turmaNome, // A turma associada ao evento
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          titulo,
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          descricao,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (imageUrl.isNotEmpty)
                          Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        const Spacer(),
                        if (_showDocumentField)
                          Column(
                            children: [
                              TextFormField(
                                controller: _pontuacaoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Pontuação',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: _aprovarEvento,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2B47FC),
                                        minimumSize: const Size(40, 40),
                                        shape: const CircleBorder()),
                                    child: const Icon(Icons.check,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Aprovar',
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: _negarEvento,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFB52FF8),
                                        minimumSize: const Size(40, 40),
                                        shape: const CircleBorder()),
                                    child: const Icon(Icons.close,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Não aprovar',
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showDocumentField =
                                            !_showDocumentField;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2B47FC),
                                        minimumSize: const Size(40, 40),
                                        shape: const CircleBorder()),
                                    child: const Icon(Icons.edit,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Documentar',
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
