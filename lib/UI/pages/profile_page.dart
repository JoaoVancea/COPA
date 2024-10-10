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
                                fontSize: 20, fontStyle: FontStyle.italic))
                      ],
                    )
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
