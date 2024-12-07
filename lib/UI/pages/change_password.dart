import 'package:copa/UI/pages/home_page.dart';
import 'package:copa/UI/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double svgWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // A ListView com o conteúdo da tela
          ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('changePassword.svg', width: svgWidth),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mudar Senha',
                            style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 50),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Senha Atual',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: const Color(0xFFB9B9B9)),
                              ),
                              PasswordField()
                            ]),
                        const SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nova Senha',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: const Color(0xFFB9B9B9)),
                              ),
                              PasswordField()
                            ]),
                        const SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confirmar Senha',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: const Color(0xFFB9B9B9)),
                              ),
                              PasswordField()
                            ]),
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
                                  onPressed: () {
                                    _changeSucessfull(context);
                                    Future.delayed(const Duration(seconds: 5), () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Mudar Senha',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20, color: Colors.white),
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
                                        height: 50, width: 85))
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
          
          // A setinha no topo esquerdo, fixada
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

void _changeSucessfull(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SvgPicture.asset('changePasswordDialog.svg'),
                const SizedBox(height: 24),
                Text(
                  'Parabéns',
                  style: GoogleFonts.montserrat(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  'Senha alterada com sucesso, você será enviado para a tela de perfil.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        );
      });
}
