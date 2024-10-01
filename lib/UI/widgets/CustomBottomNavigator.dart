import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0), // Centraliza a barra
      child: PhysicalModel(
        color: Colors.white, // Cor de fundo
        elevation: 8.0, // Elevação para sombra
        shadowColor: Colors.black.withOpacity(0.5), // Cor da sombra
        borderRadius: BorderRadius.circular(30.0), // Arredondamento das bordas
        clipBehavior: Clip.antiAlias, // Suaviza as bordas
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Bordas bem arredondadas
          child: BottomNavigationBar(
            currentIndex: selectedIndex, // Índice da página atual
            onTap: onItemTapped, // Callback quando um item é clicado
            unselectedItemColor: Colors.blue,
            selectedItemColor: Colors.black,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Colors.white, // Cor de fundo da barra
            type: BottomNavigationBarType.fixed,
            items: [
              bottomNavigationBarItem(Icons.home_outlined, 'Home'),
              bottomNavigationBarItem(Icons.bar_chart_outlined, 'Stats'),
              bottomNavigationBarItem(Icons.chat_bubble_outline, 'Chat'),
              bottomNavigationBarItem(Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

// Função para criar os itens do BottomNavigationBar
BottomNavigationBarItem bottomNavigationBarItem(IconData icon, String label) {
  return BottomNavigationBarItem(
    icon: Icon(icon), // Ícone do item
    label: label, // Rótulo do item
  );
}
