import 'package:copa/UI/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
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
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Login',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.normal,
                            fontSize: 22,
                            color: Colors.grey),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Login',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Senha',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.normal,
                            fontSize: 22,
                            color: Colors.grey),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePage()));
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Login',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    const Icon(Icons.arrow_forward, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: SvgPicture.asset('purpleMoon.svg', height: 50, width: 85))
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
