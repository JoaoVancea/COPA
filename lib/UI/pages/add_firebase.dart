import 'package:flutter/material.dart';
import 'package:copa/features/user/services/user_service.dart';
import 'package:copa/features/turma/services/turma_service.dart';
import 'package:copa/features/funcao/services/funcao_service.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:copa/features/funcao/model/funcao_model.dart';

class AddEntitiesPage extends StatefulWidget {
  @override
  _AddEntitiesPageState createState() => _AddEntitiesPageState();
}

class _AddEntitiesPageState extends State<AddEntitiesPage> {
  final UserService _userService = UserService();
  final TurmaService _turmaService = TurmaService();
  final FuncaoService _funcaoService = FuncaoService();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _turmaNameController = TextEditingController();
  final TextEditingController _funcaoNameController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _turmaNameController.dispose();
    _funcaoNameController.dispose();
    super.dispose();
  }

  void _addUser() async {
    if (_userNameController.text.isNotEmpty) {
      final user = User(id: '', nome: _userNameController.text, email: 'a', senha: 'a');
      await _userService.createUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário adicionado com sucesso!')),
      );
      _userNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um nome.')),
      );
    }
  }

  void _addTurma() async {
    if (_turmaNameController.text.isNotEmpty) {
      final turma = Turma(id: '', nome: _turmaNameController.text);
      await _turmaService.createTurma(turma);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Turma adicionada com sucesso!')),
      );
      _turmaNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um nome.')),
      );
    }
  }

  void _addFuncao() async {
    if (_funcaoNameController.text.isNotEmpty) {
      final funcao = Funcao(id: '', nome: _funcaoNameController.text);
      await _funcaoService.createFuncao(funcao);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Função adicionada com sucesso!')),
      );
      _funcaoNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um nome.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Usuário, Turma ou Função'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adicionar Usuário', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Nome do Usuário'),
            ),
            ElevatedButton(
              onPressed: _addUser,
              child: Text('Adicionar Usuário'),
            ),
            SizedBox(height: 20),

            Text('Adicionar Turma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _turmaNameController,
              decoration: InputDecoration(labelText: 'Nome da Turma'),
            ),
            ElevatedButton(
              onPressed: _addTurma,
              child: Text('Adicionar Turma'),
            ),
            SizedBox(height: 20),

            Text('Adicionar Função', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _funcaoNameController,
              decoration: InputDecoration(labelText: 'Nome da Função'),
            ),
            ElevatedButton(
              onPressed: _addFuncao,
              child: Text('Adicionar Função'),
            ),
          ],
        ),
      ),
    );
  }
}
