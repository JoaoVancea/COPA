import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do Firebase Auth
  bool _isLoading = false;

  Future<void> _login() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Tentativa de login com email e senha
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Buscar os dados do usuário no Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .get();

    bool isAdmin = userDoc['isAdmin'] ?? false; // Pega o valor de isAdmin

    // Navega para a HomePage e passa a informação se o usuário é admin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(isAdmin: isAdmin), // Passando isAdmin para a HomePage
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao fazer login: $e')),
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
      body: ListView(
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
                              onPressed: _isLoading ? null : _login, // Desabilita o botão se estiver carregando
                              child: _isLoading
                                  ? const CircularProgressIndicator() // Exibe o loader
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
                              child: SvgPicture.asset(
                                  'purpleMoon.svg',
                                  height: 50,
                                  width: 85),
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
