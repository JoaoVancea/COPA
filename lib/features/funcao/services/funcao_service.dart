import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/funcao/model/funcao_model.dart';

class FuncaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _funcoesCollection = FirebaseFirestore.instance.collection('funcoes');

  // Obtém todas as funções
  Future<List<Funcao>> getFuncoes() async {
    QuerySnapshot snapshot = await _funcoesCollection.get();
    return snapshot.docs.map((doc) => Funcao.fromFirestore(doc)).toList();
  }

  // Cria uma nova função
  Future<void> createFuncao(Funcao funcao) async {
    await _funcoesCollection.add(funcao.toFirestore());
  }

  // Atualiza uma função existente
  Future<void> updateFuncao(String id, Funcao funcao) async {
    await _funcoesCollection.doc(id).update(funcao.toFirestore());
  }

  // Deleta uma função
  Future<void> deleteFuncao(String id) async {
    await _funcoesCollection.doc(id).delete();
  }
}

