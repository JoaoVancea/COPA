import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/features/user/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  // Obtém todas os usuários
  Future<List<User>> getUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _usersCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
  }

  // Cria um novo usuário
  Future<void> createUser(User user) async {
    await _usersCollection.add(user.toFirestore());
  }

  // Atualiza um usuário existente
  Future<void> updateUser(String id, User user) async {
    await _usersCollection.doc(id).update(user.toFirestore());
  }

  // Deleta um usuário
  Future<void> deleteUser(String id) async {
    await _usersCollection.doc(id).delete();
  }
}
