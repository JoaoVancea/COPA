import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instância do Firebase Auth
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Autenticação com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Verificar se o usuário está autenticado
      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-found', message: 'Usuário não encontrado.');
      }

      // Buscar dados do usuário no Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw FirebaseAuthException(
            code: 'user-data-missing',
            message: 'Dados do usuário não encontrados no Firestore.');
      }

      // Converter para AppUser
      AppUser appUser = AppUser.fromFirestore(userDoc);

      // Navegar para HomePage com o usuário logado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(appUser: appUser),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: ${e.message}')),
      );
    } catch (e) {
      // Tratar erros genéricos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao fazer login.')),
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo da tela (ListView)
          ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('login.svg', width: svgWidth),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login',
                            style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                  color: Colors.grey),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Senha',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                  color: Colors.grey),
                            ),
                            PasswordField(controller: passwordController)
                          ],
                        ),
                        const SizedBox(height: 80),
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : _login, // Desabilita o botão se estiver carregando
                                  child: _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator()) // Exibe o loader
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Login',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              const Icon(Icons.arrow_forward,
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: SvgPicture.asset('purpleMoon.svg',
                                      height: 50, width: 85),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Setinha 
          Positioned(
            top: 20, 
            left: 16, 
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          hintText: 'Senha',
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
      ),
    );
  }
}
