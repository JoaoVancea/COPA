import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String nome;
  final String email;
  final String imgUser;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.imgUser,
    required this.isAdmin
  });

  // Método para criar um objeto User a partir de um DocumentSnapshot do Firestore
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      imgUser: data['imgUser'] ?? '',
      isAdmin: data['isAdmin'] ?? false
    );
  }

  // Método para converter um objeto User em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'imgUser': imgUser,
      'isAdmin': isAdmin
    };
  }
}
