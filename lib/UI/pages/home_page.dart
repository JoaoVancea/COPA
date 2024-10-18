import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copa/UI/pages/events_page.dart';
import 'package:copa/UI/pages/manage_classes.dart';
import 'package:copa/UI/pages/profile_page.dart';
import 'package:copa/UI/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin; // Adiciona o parâmetro isAdmin

  const HomePage({super.key, required this.isAdmin}); // Requer o isAdmin

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Função para mapear o índice da barra de navegação às páginas
  late List<Widget> _pages; // Lista de páginas pode mudar conforme o isAdmin

  @override
  void initState() {
    super.initState();

    // Definir as páginas disponíveis com base no isAdmin
    _pages = widget.isAdmin
        ? [
            HomeContent(), // Conteúdo da página inicial (HomePage)
            ManageClasses(), // Página de classes, só visível para admin
            EventsPage(),
            ProfilePage(),
          ]
        : [
            HomeContent(),
            EventsPage(),
            ProfilePage(), // Página para usuários normais
          ];
  }

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
        isAdmin: widget.isAdmin, // Passa isAdmin para o widget CustomBottomNavigationBar
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFF4960F9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
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
                      Text(
                        'Bem vindo!',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
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
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(),
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
