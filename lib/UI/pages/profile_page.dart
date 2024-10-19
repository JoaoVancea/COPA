import 'package:copa/UI/pages/change_password.dart';
import 'package:copa/UI/pages/create_user.dart';
import 'package:copa/UI/pages/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset('profilePage.svg')),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 90, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perfil',
                      style: GoogleFonts.montserrat(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Image.asset('luko.png'),
                        const SizedBox(width: 12),
                        Text('Lucas Gonzales',
                            style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF2743FD)))
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text('Função', style: GoogleFonts.roboto(fontSize: 14)),
                    const SizedBox(height: 15),
                    Text('Professor',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 14, color: const Color(0xFF2743FD))),
                    const SizedBox(height: 32),
                    Text('Tipo de Conta',
                        style: GoogleFonts.roboto(fontSize: 14)),
                    const SizedBox(height: 15),
                    Text('Administrador',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 14, color: const Color(0xFF2743FD))),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Column(children: [
              Center(
                child: Row(
                  children: [
                    Container(
                        height: 56,
                        width: 151,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: const Color(0xFF2743FD), width: 1),
                            borderRadius: BorderRadius.circular(28)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditUser()));
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Editar Perfil',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: const Color(0xFF2743FD)),
                            ),
                          ),
                        )),
                        Container(
                        height: 56,
                        width: 151,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: const Color(0xFF2743FD), width: 1),
                            borderRadius: BorderRadius.circular(28)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CreateUser()));
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Criar usuário',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: const Color(0xFF2743FD)),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                  height: 56,
                  width: 315,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xFF2743FD), width: 1),
                      borderRadius: BorderRadius.circular(28)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mudar Senha',
                        style: GoogleFonts.montserrat(
                            fontSize: 15, color: const Color(0xFF2743FD)),
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
              Container(
                  height: 56,
                  width: 315,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xFF2743FD), width: 1),
                      borderRadius: BorderRadius.circular(28)),
                  child: ElevatedButton(
                    onPressed: () {
                      _logoutConfirmation(context);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Desconectar',
                            style: GoogleFonts.montserrat(
                                fontSize: 15, color: const Color(0xFF2743FD)),
                          ),
                          const Icon(Icons.logout,
                              color: Color(0xFF2743FD), size: 25, weight: 2),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
            ]),
          ),
        ],
      ),
    );
  }
}

void _logoutConfirmation(BuildContext context) {
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
                SvgPicture.asset('logoutConfirmation.svg'),
                const SizedBox(height: 24),
                Text(
                  'Tem Certeza?',
                  style: GoogleFonts.montserrat(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: 40,
                        width: 88,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFF2743FD), width: 1),
                            borderRadius: BorderRadius.circular(50)),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sim',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: const Color(0xFF2743FD)),
                            ),
                          ),
                        )),
                    Center(
                      child: Container(
                        width: 88,
                        height: 40,
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
                                Navigator.of(context).pop();
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Não',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: SvgPicture.asset(
                                    'logoutConfirmationButton.svg'))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        );
      });
}
