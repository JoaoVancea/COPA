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
                    Container(
                        height: 56,
                        width: 315,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF2743FD),
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(28)
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: 
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                'Editar Perfil',
                                style: GoogleFonts.montserrat(fontSize: 15, color: const Color(0xFF2743FD)),
                              ),
                            ),
                        )),
                    const SizedBox(height: 16),
                    Container(
                        height: 56,
                        width: 315,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF2743FD),
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(28)
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: 
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                'Mudar Senha',
                                style: GoogleFonts.montserrat(fontSize: 15, color: const Color(0xFF2743FD)),
                              ),
                            ),
                        )),
                    const SizedBox(height: 16),
                    Container(
                        height: 56,
                        width: 315,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF2743FD),
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(28)
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: 
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Desconectar',
                                    style: GoogleFonts.montserrat(fontSize: 15, color: const Color(0xFF2743FD)),
                                  ),
                                  const Icon(Icons.logout, color: Color(0xFF2743FD), size: 15, weight: 2),
                                ],
                              ),
                            ),
                        )),
                    const SizedBox(height: 16),
                    
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
