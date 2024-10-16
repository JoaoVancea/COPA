import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4960F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          backgroundColor: const Color(0xFF4960F9),
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Center(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset('behindPhoto.svg'),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(35),
                            child: SvgPicture.asset('camera.svg'),
                          ),
                        )
                      ],
                    ),
                  ))),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            Text('Nome',
                style: GoogleFonts.roboto(
                    fontSize: 14, color: const Color(0xFF80E0FF))),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Nicolas',
                  hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Color(0xFFCB3EF9),
                    ),
                    onPressed: () {},
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(height: 20),
            Text('Sobrenome',
                style: GoogleFonts.roboto(
                    fontSize: 14, color: const Color(0xFF80E0FF))),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Barbosa',
                  hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Color(0xFFCB3EF9),
                    ),
                    onPressed: () {},
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(height: 20),
            Text('Email',
                style: GoogleFonts.roboto(
                    fontSize: 14, color: const Color(0xFF80E0FF))),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  hintText: 'nicolasbarbosap@yahoo.com',
                  hintStyle: const TextStyle(color: Color(0xFFC0C4C8)),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Color(0xFFCB3EF9),
                    ),
                    onPressed: () {},
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 65),
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28)),
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text('Finalizar',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: const Color(0xFF1937FE))),
                          const SizedBox(width: 22),
                          const Icon(Icons.check, color: Color(0xFF1937FE))
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
