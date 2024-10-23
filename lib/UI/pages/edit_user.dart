import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUser extends StatefulWidget {
  AppUser appUser;
  EditUser({super.key, required this.appUser});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    emailController.text = widget.appUser.email;
    nomeController.text = widget.appUser.nome;
  }

  Future<void> _updateData() async {
    try {
      await _firestore.collection('users').doc(widget.appUser.id).update({
        'nome': nomeController.text.trim()
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!'))
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar perfil'))
      );
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF4960F9),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
          child: ListView(
            children: [
              Stack(
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
              const SizedBox(height: 15),
              Text('Nome',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                controller: nomeController,
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
              Text('Email',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: const Color(0xFF80E0FF))),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                readOnly: true,
                controller: emailController,
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize:
                                const Size(double.infinity, double.infinity)),
                        onPressed: () {
                          _updateData();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
      ]),
    );
  }
}
