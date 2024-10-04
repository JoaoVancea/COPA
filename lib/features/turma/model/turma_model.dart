import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  final String id;
  final String nome;

  Turma({
    required this.id,
    required this.nome,
  });

  // Método para criar um objeto Turma a partir de um DocumentSnapshot do Firestore
  factory Turma.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Turma(
      id: doc.id,
      nome: data['nome'] ?? '',
    );
  }

  // Método para converter um objeto Turma em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
    };
  }
}
