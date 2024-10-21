import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:copa/features/userTurma/model/user_turma_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUserTurma extends StatefulWidget {
  String userId;
  String userTurmaId;
  EditUserTurma({super.key, required this.userId, required this.userTurmaId});

  @override
  State<EditUserTurma> createState() => _EditUserTurmaState();
}

class _EditUserTurmaState extends State<EditUserTurma> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? appUser;
  UserTurma? userTurma;
  bool? isAtivo;

  // Pegando dados do usuário e userTurma
  Future<void> _getData() async {
    try {
      // Recupera o documento do usuário
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      AppUser fetchedAppUser = AppUser.fromFirestore(userDoc);

      // Recupera o documento userTurma
      DocumentSnapshot userTurmaDoc = await _firestore
          .collection('userTurma')
          .doc(widget.userTurmaId)
          .get();
      UserTurma fetchedUserTurma = UserTurma.fromFirestore(userTurmaDoc);

      // Atualiza o estado com os dados carregados
      setState(() {
        appUser = fetchedAppUser;
        userTurma = fetchedUserTurma;
        isAtivo = fetchedUserTurma.statusAtivo; // Atualiza o estado

        nomeController.text = fetchedAppUser.nome;
        emailController.text = fetchedAppUser.email;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao recuperar usuário')),
      );
    }
  }

  Future<void> _updateData() async {
    try {
      await _firestore.collection('users').doc(widget.userId).update({
        'nome': nomeController.text.trim(),
        'email': emailController.text.trim()
      });

      await _firestore.collection('userTurma').doc(widget.userTurmaId).update({
        'ativo': isAtivo
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário atualizado com sucesso!'))
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar usuário'))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se os dados estão carregados
    if (appUser == null || userTurma == null || isAtivo == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Exibe um loader enquanto carrega
    }

    return Scaffold(
      backgroundColor: const Color(0xFF4960F9),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
            child: ListView(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset('behindPhoto.svg'),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: SvgPicture.asset('camera.svg'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Text('Nome',
                    style: GoogleFonts.roboto(
                        fontSize: 14, color: const Color(0xFF80E0FF))),
                const SizedBox(height: 10),
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    hintText: 'Nicolas',
                    hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xFFCB3EF9),
                      ),
                      onPressed: () {},
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Email',
                    style: GoogleFonts.roboto(
                        fontSize: 14, color: const Color(0xFF80E0FF))),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'nicolasbarbosap@yahoo.com',
                    hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xFFCB3EF9),
                      ),
                      onPressed: () {},
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Estado',
                        style: GoogleFonts.roboto(
                            color: const Color(0xFF80E0FF), fontSize: 14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio<bool>(
                          value: true,
                          groupValue: isAtivo,
                          onChanged: (bool? value) {
                            setState(() {
                              isAtivo = value;
                            });
                          },
                        ),
                        const Text('Ativo'),
                        Radio<bool>(
                          value: false,
                          groupValue: isAtivo,
                          onChanged: (bool? value) {
                            setState(() {
                              isAtivo = value;
                            });
                          },
                        ),
                        const Text('Inativo'),
                      ],
                    ),
                  ],
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
                              const Size(double.infinity, double.infinity),
                        ),
                        onPressed: () {
                          _updateData();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Finalizar',
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color: const Color(0xFF1937FE))),
                            const SizedBox(width: 22),
                            const Icon(Icons.check, color: Color(0xFF1937FE)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
