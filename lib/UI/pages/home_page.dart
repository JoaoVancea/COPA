import 'package:copa/UI/pages/add_firebase.dart';
import 'package:copa/UI/pages/manage_classes.dart';
import 'package:copa/UI/pages/profile_page.dart';
import 'package:flutter/material.dart';
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
    AdminPage(),
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

// Widget que representa o conteúdo da HomePage
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Bem-vindo à Home!'), // Conteúdo da HomePage
    );
  }
}
