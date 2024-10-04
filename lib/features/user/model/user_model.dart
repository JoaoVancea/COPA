import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nome;
  final String email;
  final String senha;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // Método para criar um objeto User a partir de um DocumentSnapshot do Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      senha: data['senha'] ?? '',
    );
  }

  // Método para converter um objeto User em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}
