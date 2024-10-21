import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  final String id;
  final String nome;
  final bool ativo;
  final String sigla;
  final String turma;


  Turma({
    required this.id,
    required this.nome,
    required this.ativo,
    required this.sigla,
    required this.turma});

  // Método para criar um objeto Turma a partir de um DocumentSnapshot do Firestore
  factory Turma.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Turma(
      id: doc.id,
      nome: data['nome'] ?? '',
      ativo: data['ativo'] ?? false,
      sigla: data['sigla'] ?? '',
      turma: data['turma'] ?? ''
    );
  }

  // Método para converter um objeto Turma em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'ativo': ativo,
      'sgila': sigla
    };
  }
}
