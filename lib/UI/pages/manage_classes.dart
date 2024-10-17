import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageClasses extends StatefulWidget {
  const ManageClasses({super.key});

  @override
  State<ManageClasses> createState() => _ManageClassesState();
}

class _ManageClassesState extends State<ManageClasses> {
  String? selectedClass = '3DS';
  final List<String> classes = ['3DS', '2DS', '1DS'];

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
                  const SizedBox(height: 10),
                  Text('Gerenciar Turmas',
                      style: GoogleFonts.montserrat(
                          fontSize: 24, color: Colors.white)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              side: const BorderSide(
                                  color: Colors.white, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              minimumSize: const Size(151, 56)),
                          onPressed: () {},
                          child: Text(
                            'Criar Turma',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.white),
                          )),
                      const SizedBox(width: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              side: const BorderSide(
                                  color: Colors.white, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              minimumSize: const Size(151, 56)),
                          onPressed: () {},
                          child: Text(
                            'Editar Turma',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 280, 20, 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xFFDFDFDF),
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedClass,
                        items: classes.map((String className) {
                          return DropdownMenuItem<String>(
                            value: className,
                            child: Text(className),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: const Color(0xFFF2F4F8))),
                        child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              hintText: 'Presença',
                              hintStyle: GoogleFonts.montserrat(
                                  color: const Color(0xFF979797))),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: const Color(0xFFF2F4F8))),
                        child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              hintText: 'Evento',
                              hintStyle: GoogleFonts.montserrat(
                                  color: const Color(0xFF979797))),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Atribuir Pontos',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15, color: Colors.white),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          )
        ])
      ]),
    );
  }
}
