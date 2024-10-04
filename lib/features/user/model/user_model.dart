import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String nome;
  String email;
  String senha;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // Construtor a partir de documento do Firestore
  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,  // O id do documento
      nome: data['nome'],
      email: data['email'],
      senha: data['senha'],
    );
  }

  factory User.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return User(
      id: doc.id,
      nome: doc.data()['nome'],
      email: doc.data()['email'],
      senha: doc.data()['senha'],
    );
  }

  // Método para converter User em um mapa para o Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}
