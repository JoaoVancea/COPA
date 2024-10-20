import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool? isAdmin; // Agora pode ser null

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: PhysicalModel(
        color: Colors.white,
        elevation: 8.0,
        shadowColor: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30.0),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            unselectedItemColor: Colors.blue,
            selectedItemColor: Colors.black,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: _buildBottomNavigationBarItems(),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [
      bottomNavigationBarItem(Icons.home_outlined, 'Home'),
      bottomNavigationBarItem(Icons.person_outline, 'Profile'),
    ];

    // Se isAdmin for true, adicionar itens específicos
    if (isAdmin != null) {
      if (isAdmin!) {
        items.insert(1, bottomNavigationBarItem(Icons.bar_chart_outlined, 'Manage Classes'));
        items.insert(2, bottomNavigationBarItem(Icons.chat_bubble_outline, 'Chat'));
      } else {
        items.insert(1, bottomNavigationBarItem(Icons.chat_bubble_outline, 'Chat'));
      }
    }

    // Caso isAdmin seja nulo, exibir apenas Home e Profile
    return items;
  }
}


// Função para criar os itens do BottomNavigationBar
BottomNavigationBarItem bottomNavigationBarItem(IconData icon, String label) {
  return BottomNavigationBarItem(
    icon: Icon(icon), // Ícone do item
    label: label, // Rótulo do item
  );
}
