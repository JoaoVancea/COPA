import 'package:cloud_firestore/cloud_firestore.dart';

class UserTurma {
  final String userId;
  final String turmaId;
  final String funcaoId;
  final bool statusAtivo;

  UserTurma({
    required this.userId,
    required this.turmaId,
    required this.funcaoId,
    required this.statusAtivo,
  });

  // Método para criar um objeto UserTurma a partir de um DocumentSnapshot do Firestore
  factory UserTurma.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserTurma(
      userId: data['user_id'] ?? '',
      turmaId: data['turma_id'] ?? '',
      funcaoId: data['funcao_id'] ?? '',
      statusAtivo: data['status'] ?? false,
    );
  }

  // Método para converter um objeto UserTurma em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'turma_id': turmaId,
      'funcao_id': funcaoId,
      'status': statusAtivo,
    };
  }
}
