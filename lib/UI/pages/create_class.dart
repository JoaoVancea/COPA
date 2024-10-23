import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  bool _isLoading = false;

  final TextEditingController nomeTurmaController = TextEditingController();
  final TextEditingController turmaController = TextEditingController();
  final TextEditingController siglaController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> criarTurma() async {
    if (nomeTurmaController.text.trim().isEmpty ||
        turmaController.text.trim().isEmpty ||
        siglaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('turmas').add({
        'nome': nomeTurmaController.text.trim(),
        'turma': turmaController.text.trim().toUpperCase(),
        'sigla': siglaController.text.trim().toUpperCase(),
        'ativo': true
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Turma criada com sucesso!')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao criar turma')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double svgWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFF4960F9),
      body: Stack(children: [
        Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset('editClass.svg', width: svgWidth)),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(35),
                      child: SvgPicture.asset('camera.svg'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text('Nome da Turma',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: nomeTurmaController,
                decoration: const InputDecoration(
                    hintText: 'Nome da Turma',
                    hintStyle: TextStyle(color: Color(0xFFC0C4C8)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Text('Turma',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: turmaController,
                decoration: const InputDecoration(
                    hintText: 'Turma',
                    hintStyle: TextStyle(color: Color(0xFFC0C4C8)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Text('Sigla (MAX: 3 Letras)',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: siglaController,
                decoration: const InputDecoration(
                    hintText: 'Sigla',
                    hintStyle: TextStyle(color: Color(0xFFC0C4C8)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 65),
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28)),
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize:
                                const Size(double.infinity, double.infinity)),
                        onPressed: _isLoading ? null : criarTurma,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Finalizar',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          color: const Color(0xFF1937FE))),
                                  const SizedBox(width: 22),
                                  const Icon(Icons.check,
                                      color: Color(0xFF1937FE))
                                ],
                              )),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
