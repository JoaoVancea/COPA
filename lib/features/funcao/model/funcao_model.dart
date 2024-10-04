import 'package:cloud_firestore/cloud_firestore.dart';

class Funcao {
  final String id;
  final String nome;

  Funcao({
    required this.id,
    required this.nome,
  });

  // Método para criar um objeto Funcao a partir de um DocumentSnapshot do Firestore
  factory Funcao.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Funcao(
      id: doc.id,
      nome: data['nome'] ?? '',
    );
  }

  // Método para converter um objeto Funcao em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
    };
  }
}
