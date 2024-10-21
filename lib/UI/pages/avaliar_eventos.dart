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
  bool _showDocumentField = false; // Controla a visibilidade do campo de pontuação
  final TextEditingController _pontuacaoController = TextEditingController(text: '10'); // Valor padrão

  Future<void> _aprovarEvento() async {
    await _firestore.collection('evento').doc(widget.eventoId).update({
      'valor': int.parse(_pontuacaoController.text), // Usa a pontuação fornecida ou a padrão (10)
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
          final String userId = evento['user']; // ID do usuário que criou o evento

          return FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('users').doc(userId).get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = userSnapshot.data!.data() as Map<String, dynamic>;
              final String userNome = user['nome'];
              final String userFoto = user['imgUser'];
              final String userTurma = '4DS'; // A turma do usuário (exemplo)

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
                              userTurma, // A turma do usuário
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
                    const Spacer(),
                    // Se o admin optar por documentar, um campo de texto aparecerá para inserir a pontuação
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
                    // Container de opções
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
                          ElevatedButton.icon(
                            onPressed: _aprovarEvento,
                            icon: const Icon(Icons.check),
                            label: const Text("Aprovar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(120, 50),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _negarEvento,
                            icon: const Icon(Icons.close),
                            label: const Text("Não Aprovar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(120, 50),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showDocumentField = !_showDocumentField;
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Documentar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(120, 50),
                            ),
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
      ),
    );
  }
}
