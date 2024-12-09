import 'package:copa/features/turma/model/turma_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditClass extends StatefulWidget {
  final Turma turma; // Turma recebida para edição

  EditClass({super.key, required this.turma});

  @override
  State<EditClass> createState() => _EditClassState();
}

class _EditClassState extends State<EditClass> {
  final TextEditingController nomeTurma = TextEditingController();
  final TextEditingController classeTurma = TextEditingController();
  final TextEditingController siglaTurma = TextEditingController();

  bool _isLoading = false; // Estado de carregamento

  @override
  void initState() {
    super.initState();
    // Inicializar os controladores com os valores atuais da turma
    nomeTurma.text = widget.turma.nome;
    classeTurma.text = widget.turma.turma;
    siglaTurma.text = widget.turma.sigla;
  }

  /// Atualiza os dados da turma no Firestore
  Future<void> _updateTurma() async {
    // Validação dos campos
    if (nomeTurma.text.trim().isEmpty ||
        classeTurma.text.trim().isEmpty ||
        siglaTurma.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    // Limite de 3 letras para a sigla
    if (siglaTurma.text.trim().length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A sigla deve ter no máximo 3 letras')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Atualizar os dados da turma no Firestore
      await FirebaseFirestore.instance
          .collection('turmas')
          .doc(widget.turma.id)
          .update({
        'nome': nomeTurma.text.trim(),
        'turma': classeTurma.text.trim(),
        'sigla': siglaTurma.text.trim(),
      });

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Turma atualizada com sucesso!')),
      );

      // Voltar para a tela anterior
      Navigator.pop(context);
    } catch (e) {
      // Exibir mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar turma: $e')),
      );
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
              TextFormField(
                controller: nomeTurma,
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                    hintText: 'Garotos de Programa',
                    hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xFFCB3EF9),
                      ),
                      onPressed: () {}, // Ação opcional
                    ),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Text('Turma',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFFFFFFFF))),
              const SizedBox(height: 10),
              TextFormField(
                controller: classeTurma,
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                    hintText: '3DS',
                    hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xFFCB3EF9),
                      ),
                      onPressed: () {}, // Ação opcional
                    ),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Text('Sigla (MAX: 3 Letras)',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextFormField(
                controller: siglaTurma,
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                    hintText: 'GPS',
                    hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xFFCB3EF9),
                      ),
                      onPressed: () {}, // Ação opcional
                    ),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const UnderlineInputBorder(
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
                        onPressed: _isLoading
                            ? null
                            : _updateTurma, // Chama a função de atualização
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
