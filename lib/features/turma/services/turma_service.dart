import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/turma/model/turma_model.dart';


class TurmaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _turmasCollection = FirebaseFirestore.instance.collection('turmas');

   // Obtém todas as turmas
  Future<List<Turma>> getTurmas() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _turmasCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs.map((doc) => Turma.fromFirestore(doc)).toList();
  }

  // Cria uma nova turma
  Future<void> createTurma(Turma turma) async {
    await _turmasCollection.add(turma.toFirestore());
  }

  // Atualiza uma turma existente
  Future<void> updateTurma(String id, Turma turma) async {
    await _turmasCollection.doc(id).update(turma.toFirestore());
  }

  // Deleta uma turma
  Future<void> deleteTurma(String id) async {
    await _turmasCollection.doc(id).delete();
  }
}
