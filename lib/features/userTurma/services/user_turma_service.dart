import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/userTurma/model/user_turma_model.dart';

class UserTurmaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userTurmaCollection = FirebaseFirestore.instance.collection('userTurma');

  // Obtém todas as relações User-Turma
  Future<List<UserTurma>> getUserTurmas() async {
    QuerySnapshot snapshot = await _userTurmaCollection.get();
    return snapshot.docs.map((doc) => UserTurma.fromFirestore(doc)).toList();
  }

  // Cria uma nova relação User-Turma
  Future<void> createUserTurma(UserTurma userTurma) async {
    await _userTurmaCollection.add(userTurma.toFirestore());
  }

  // Atualiza uma relação User-Turma existente
  Future<void> updateUserTurma(String id, UserTurma userTurma) async {
    await _userTurmaCollection.doc(id).update(userTurma.toFirestore());
  }

  // Deleta uma relação User-Turma
  Future<void> deleteUserTurma(String id) async {
    await _userTurmaCollection.doc(id).delete();
  }
}
