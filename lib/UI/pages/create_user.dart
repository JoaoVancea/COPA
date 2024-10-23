import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  bool? isAdmin = true; // Estado booleano para isAdmin
  bool _isLoading = false; // Estado de carregamento

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getDefaultUserPhotoUrl() async {
    String gsPath = 'gs://copa-e8ad2.appspot.com/defaultAvatar.jpg';

    //Referência ao arquivo no Firebase Storage
    Reference ref = FirebaseStorage.instance.refFromURL(gsPath);

    //Obtenha a URL pública do arquivo
    String downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> criarUsuario() async {
    // Validação de campos obrigatórios
    if (nomeController.text.trim().isEmpty ||
        sobrenomeController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //Obtenha a URL pública da foto padrão
      String userPhotoUrl = await getDefaultUserPhotoUrl();

      // Criar usuário com email e senha padrão
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: 'Senai123', // Senha padrão
      );

      // Salvar dados do usuário no Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'nome':
            nomeController.text.trim() + ' ' + sobrenomeController.text.trim(),
        'email': emailController.text.trim(),
        'imgUser': userPhotoUrl, // Defina o link da foto padrão aqui
        'isAdmin': isAdmin, // Usando diretamente o booleano
      });

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário criado com sucesso!')),
      );

      // Voltar à página anterior
      Navigator.pop(context);
    } catch (e) {
      // Tratar erros ao criar usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar usuário: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4960F9),
      body: Stack(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
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
                        color: Colors.white),
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
              TextField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: nomeController,
                decoration: const InputDecoration(
                    hintText: 'Seu nome',
                    hintStyle: TextStyle(color: Color(0xFFC0C4C8)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Text('Sobrenome',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: sobrenomeController,
                decoration: const InputDecoration(
                    hintText: 'Seu sobrenome',
                    hintStyle: TextStyle(color: Color(0xFFC0C4C8)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Text('Email',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: 'Seu email',
                    hintStyle: TextStyle(color: Color(0xFFC0C4C8)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Admin',
                      style: GoogleFonts.roboto(
                          color: const Color(0xFF80E0FF), fontSize: 14)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<bool>(
                        value: true,
                        groupValue: isAdmin,
                        onChanged: (bool? value) {
                          setState(() {
                            isAdmin = value;
                          });
                        },
                      ),
                      const Text('true'),
                      Radio<bool>(
                        value: false,
                        groupValue: isAdmin,
                        onChanged: (bool? value) {
                          setState(() {
                            isAdmin = value;
                          });
                        },
                      ),
                      const Text('false')
                    ],
                  )
                ],
              ),
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
                            ? null // Desabilita o botão durante o carregamento
                            : criarUsuario, // Chama a função ao finalizar
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
                                      color: Color(0xFF1937FE)),
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
