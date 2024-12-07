import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  AppUser appUser;
  CreateEvent({super.key, required this.appUser});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Turma? _selectedClass;
  List<Turma> _userClasses = [];
  final ImagePicker _picker = ImagePicker();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Uint8List? _selectedImage; // Para armazenar a imagem em bytes (Web ou Mobile)
  XFile? _selectedImageFile; // Para dispositivos móveis

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

Future<void> _removeImage() async {
    setState(() {
      _selectedImage = null;
      _selectedImageFile = null;
    });
  }

  Future<void> _selectImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          // Para Web: Leia os bytes diretamente
          final Uint8List bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedImage = bytes;
          });
        } else {
          // Para dispositivos móveis: Trabalhe com File
          setState(() {
            _selectedImageFile = pickedFile;
          });
        }
      }
    } catch (e) {
      print('Erro ao selecionar a imagem: $e');
    }
  }

  Future<void> _fetchClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userTurma')
          .where('userId', isEqualTo: widget.appUser.id)
          .where('ativo', isEqualTo: true)
          .get();

      List<Turma> classes = [];

      for (var doc in snapshot.docs) {
        String turmaId = doc['turmaId'];
        DocumentSnapshot turmaSnapshot =
            await _firestore.collection('turmas').doc(turmaId).get();

        if (turmaSnapshot.exists) {
          Turma turma = Turma(
              id: turmaSnapshot.id,
              nome: turmaSnapshot['nome'],
              ativo: turmaSnapshot['ativo'],
              turma: turmaSnapshot['turma'],
              sigla: turmaSnapshot['sigla']);
          classes.add(turma);
        }
      }

      setState(() {
        _userClasses = classes;
        _isLoading = false;

        if (_userClasses.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você não está ativo em nenhuma turma.'),
            ),
          );
          Navigator.pop(context);
        }

        if (_userClasses.length == 1) {
          _selectedClass = _userClasses.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao carregar turmas: $e')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createEvent() async {
    if (tituloController.text.trim().isEmpty ||
        descricaoController.text.trim().isEmpty ||
        _selectedClass == null ||
        (_selectedImage == null && _selectedImageFile == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Preencha todos os campos e anexe uma imagem')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;

      // Upload da imagem baseado na plataforma
      if (kIsWeb && _selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('event_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await storageRef.putData(_selectedImage!);
        imageUrl = await uploadTask.ref.getDownloadURL();
      } else if (_selectedImageFile != null) {
        final File imageFile = File(_selectedImageFile!.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('event_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await storageRef.putFile(imageFile);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      await _firestore.collection('evento').add({
        'titulo': tituloController.text.trim(),
        'descricao': descricaoController.text.trim(),
        'valor': 0,
        'turmaId': _selectedClass!.id,
        'user': widget.appUser.id,
        'dataCriacao': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento adicionado com sucesso!')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao enviar evento')));
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(110),
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4960F9), Color(0xFF1937FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Adicionar Evento',
                  style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Adicionado para evitar overflow em telas menores
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título', style: GoogleFonts.roboto(fontSize: 14)),
            const SizedBox(height: 8),
            TextFormField(
              controller: tituloController,
              decoration: InputDecoration(
                  hintText: 'Insira um título',
                  hintStyle: GoogleFonts.roboto(
                      fontSize: 16, color: const Color(0xFFD0D1DB)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD0D1DB)),
                      borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(height: 24),
            Text('Descrição', style: GoogleFonts.roboto(fontSize: 14)),
            const SizedBox(height: 8),
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(
                  hintText: 'Descreva o evento',
                  hintStyle: GoogleFonts.roboto(
                      fontSize: 16, color: const Color(0xFFD0D1DB)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(height: 24),
            if (_userClasses.length > 1)
              DropdownButtonFormField<Turma>(
                value: _selectedClass,
                items: _userClasses
                    .map((turma) => DropdownMenuItem(
                          value: turma,
                          child: Text(turma.turma),
                        ))
                    .toList(),
                onChanged: (Turma? turma) {
                  setState(() {
                    _selectedClass = turma;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Selecione a turma',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            SizedBox(
  width: double.infinity,
  height: 56,
  child: OutlinedButton(
    onPressed: _selectImage, 
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white, 
      foregroundColor: Color(0xFF2743FD), 
      side: const BorderSide(color: Color(0xFF2743FD), width: 1), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), 
      ),
    ),
    child: Text(
      'Selecionar Imagem',
      style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: const Color(0xFF2743FD),
                ),
      
    ),
  ),
),

            const SizedBox(height: 24),
            // Exibição da Imagem Selecionada e Botão de Remover
            if (_selectedImage != null || _selectedImageFile != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedImage != null)
                    Image.memory(
                      _selectedImage!,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  else if (_selectedImageFile != null)
                    Image.file(
                      File(_selectedImageFile!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _removeImage,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
  width: double.infinity,
  height: 56,
  child: OutlinedButton(
    onPressed: _isLoading ? null : _createEvent,
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white, 
      foregroundColor: Color(0xFF2743FD), 
      side: const BorderSide(color: Color(0xFF2743FD), width: 1), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), 
      ),
    ),
    child: _isLoading
        ? const CircularProgressIndicator()
        : Text(
            'Adicionar Evento',
            style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color:  Color(0xFF2743FD),
                ),
          ),
  ),
),

          ],
        ),
      ),
    ),
  );
}
}