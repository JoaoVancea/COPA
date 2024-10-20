import 'package:copa/UI/pages/events_page.dart';
import 'package:copa/UI/pages/manage_classes.dart';
import 'package:copa/UI/pages/profile_page.dart';
import 'package:copa/UI/widgets/custom_bottom_navigation_bar.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final AppUser? appUser; // Parâmetro pode ser nulo

  HomePage({super.key, required this.appUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Definir páginas com base na condição do appUser
    if (widget.appUser != null && widget.appUser!.isAdmin != null) {
      _pages = widget.appUser!.isAdmin
          ? [
              HomeContent(),
              ManageClasses(),
              EventsPage(),
              ProfilePage(appUser: widget.appUser!),
            ]
          : [
              HomeContent(),
              EventsPage(),
              ProfilePage(appUser: widget.appUser!),
            ];
    } else {
      // Usuário deslogado
      _pages = [
        HomeContent(),
        ProfilePage(appUser: widget.appUser), // Página para usuários anônimos
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isAdmin: widget.appUser?.isAdmin, // Pode ser nulo
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
