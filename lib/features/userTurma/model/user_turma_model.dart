import 'package:cloud_firestore/cloud_firestore.dart';

class UserTurma {
  String id;
  String userId;
  String turmaId;
  String funcaoId;
  bool status;

  UserTurma({
    required this.id,
    required this.userId,
    required this.turmaId,
    required this.funcaoId,
    required this.status,
  });

  factory UserTurma.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserTurma(
      id: doc.id,
      userId: data['user_id'],
      turmaId: data['turma_id'],
      funcaoId: data['funcao_id'],
      status: data['status'],
    );
  }

  factory UserTurma.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return UserTurma(
      id: doc.id,
      userId: doc.data()['user_id'],
      turmaId: doc.data()['turma_id'],
      funcaoId: doc.data()['funcao_id'],
      status: doc.data()['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'turma_id': turmaId,
      'funcao_id': funcaoId,
      'status': status,
    };
  }
}
