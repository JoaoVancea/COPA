import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateEvent extends StatefulWidget {
  AppUser appUser;
  CreateEvent({super.key, required this.appUser});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Turma? _selectedClass;
  List<Turma> _userClasses = [];

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userTurma')
          .where('userId', isEqualTo: widget.appUser.id)
          .where('ativo', isEqualTo: true) // Considera apenas turmas ativas
          .get();

      List<Turma> classes = [];

      for (var doc in snapshot.docs) {
        String turmaId = doc['turmaId'];
        // Busca a turma na coleção de turmas com base no 'turmaId'
        DocumentSnapshot turmaSnapshot =
            await _firestore.collection('turmas').doc(turmaId).get();

        if (turmaSnapshot.exists) {
          Turma turma = Turma(
            id: turmaSnapshot.id,
            nome: turmaSnapshot['nome'],
            ativo: turmaSnapshot['ativo'],
            turma: turmaSnapshot['turma'],
            sigla: turmaSnapshot['sigla'] // Adapte de acordo com os campos do seu modelo
          );
          classes.add(turma);
        }
      }

      setState(() {
        _userClasses = classes;
        _isLoading = false;

        // Se nenhuma turma ativa for encontrada, exibe uma SnackBar
        if (_userClasses.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você não está ativo em nenhuma turma.'),
            ),
          );
          Navigator.pop(context);
        }

        // Se houver apenas uma turma ativa, ela será automaticamente selecionada
        if (_userClasses.length == 1) {
          _selectedClass = _userClasses.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar turmas: $e')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createEvent() async {
    if (tituloController.text.trim().isEmpty ||
        descricaoController.text.trim().isEmpty ||
        _selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('evento').add({
        'titulo': tituloController.text.trim(),
        'descricao': descricaoController.text.trim(),
        'valor': 0,
        'turmaId': _selectedClass!.id, // Adiciona a turma selecionada
        'user': widget.appUser.id,
        'dataCriacao': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso!')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao enviar evento')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4960F9), Color(0xFF1937FE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Função para voltar
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text('Add Evento',
                      style: GoogleFonts.roboto(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Título', style: GoogleFonts.roboto(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: tituloController,
                decoration: InputDecoration(
                    hintText: 'Insira um título',
                    hintStyle: GoogleFonts.roboto(
                        fontSize: 16, color: const Color(0xFFD0D1DB)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFD0D1DB)),
                        borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 24),
              Text('Descrição', style: GoogleFonts.roboto(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(
                    hintText: 'Descreva o evento',
                    hintStyle: GoogleFonts.roboto(
                        fontSize: 16, color: const Color(0xFFD0D1DB)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 24),
              // Exibe o DropdownButton apenas se o usuário tiver mais de uma turma
              if (_userClasses.length > 1)
                DropdownButtonFormField<Turma>(
                  value: _selectedClass,
                  items: _userClasses
                      .map((turma) => DropdownMenuItem(
                            value: turma,
                            child: Text(turma.turma),
                          ))
                      .toList(),
                  onChanged: (Turma? turma) {
                    setState(() {
                      _selectedClass = turma;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Selecione a turma',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                    onPressed: _createEvent,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFECF9FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0),
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFF03A9F4),
                    ),
                    label: Text('Anexar',
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: const Color(0xFF03A9F4)))),
              ),
            ],
          ),
        ));
  }
}
