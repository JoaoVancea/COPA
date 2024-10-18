import 'package:copa/UI/pages/add_firebase.dart';
import 'package:copa/UI/pages/create_class.dart';
import 'package:copa/UI/pages/edit_class.dart';
import 'package:copa/UI/pages/events_page.dart';
import 'package:copa/UI/pages/manage_classes.dart';
import 'package:copa/UI/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teste_firebase.dart'; // Importe a página do formulário
import 'package:copa/UI/widgets/custom_bottom_navigation_bar.dart'; // Importe o widget customizado

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Função para mapear o índice da barra de navegação às páginas
  final List<Widget> _pages = [
    HomeContent(), // Conteúdo da página inicial (HomePage)
    ManageClasses(), // Página com o formulário de vinculação UserTurma
    EventsPage(),
    ProfilePage() // Página para adicionar ao firestore
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Exibe a página correspondente
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Função callback
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                color: Color(0xFF4960F9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                        child: SvgPicture.asset('logoCopa.svg'),
                      ),
                      Image.asset('luko.png')
                    ],
                  ),
                  Text('Bem vindo!',
                      style: GoogleFonts.montserrat(
                          fontSize: 24, color: Colors.white)),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 280, 20, 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFFDFDFDF),
                      borderRadius: BorderRadius.circular(40)),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column()
                  ),
                ),
              ],
            ),
          )
        ])
      ]),
    );
  }
}
