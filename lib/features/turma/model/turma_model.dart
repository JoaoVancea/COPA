import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  String id;
  String nome;

  Turma({
    required this.id,
    required this.nome,
  });

  factory Turma.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Turma(
      id: doc.id,
      nome: data['nome'],
    );
  }

  factory Turma.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Turma(
      id: doc.id,
      nome: doc.data()['nome'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
    };
  }
}
