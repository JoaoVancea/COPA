import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe que representa um usuário no aplicativo.
class AppUser {
  final String id;
  final String nome;
  final String email;
  final String imgUser;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.imgUser,
    required this.isAdmin,
  });

  /// Cria uma instância de AppUser a partir de um [DocumentSnapshot] do Firestore.
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Document snapshot sem dados');
    }

    return AppUser(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      email: data['email'] as String? ?? '',
      imgUser: data['imgUser'] as String? ?? '',
      isAdmin: data['isAdmin'] as bool? ?? false,
    );
  }

  /// Converte a instância de AppUser em um Map para salvar no Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'email': email,
      'imgUser': imgUser,
      'isAdmin': isAdmin,
    };
  }

  /// Método auxiliar para criar uma lista de AppUser a partir de uma coleção do Firestore.
  static List<AppUser> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
  }

  /// Atualiza campos específicos de um usuário no Firestore.
  Future<void> updateInFirestore(DocumentReference docRef) async {
    await docRef.update(toFirestore());
  }
}
