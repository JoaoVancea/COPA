import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageClasses extends StatefulWidget {
  const ManageClasses({super.key});

  @override
  State<ManageClasses> createState() => _ManageClassesState();
}

class _ManageClassesState extends State<ManageClasses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(
          alignment: Alignment.center,
          children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                color: const Color(0xFF4960F9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70))),
            child: Padding(
              padding: EdgeInsets.all(20),
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
            padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 315,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child: Padding(padding: EdgeInsets.all(20), child: Column(
                    children: [
                      DropdownForm(),

                    ],
                  ),),
                )
              ],
            ),
          )
        ])
      ]),
    );
  }
}

class DropdownForm extends StatefulWidget {
  @override
  _DropdownFormState createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  String? selectedValue;

  final List<String> options = ['1DS', '2DS', '3DS'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          hint: Text('Selecione uma turma'),
          value: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        if (selectedValue != null) 
          Text('You selected: $selectedValue'),
      ],
    );
  }
}
