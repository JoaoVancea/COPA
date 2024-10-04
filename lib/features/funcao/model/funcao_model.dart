import 'package:cloud_firestore/cloud_firestore.dart';

class Funcao {
  String id;
  String nome;

  Funcao({
    required this.id,
    required this.nome,
  });

  factory Funcao.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Funcao(
      id: doc.id,
      nome: data['nome'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
    };
  }
}
