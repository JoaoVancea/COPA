import 'package:copa/features/funcao/model/funcao_model.dart';
import 'package:copa/features/funcao/services/funcao_service.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:copa/features/turma/services/turma_service.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:copa/features/user/services/user_service.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final UserService _userService = UserService();
  final TurmaService _turmaService = TurmaService();
  final FuncaoService _funcaoService = FuncaoService();

  final _userFormKey = GlobalKey<FormState>();
  final _turmaFormKey = GlobalKey<FormState>();
  final _funcaoFormKey = GlobalKey<FormState>();

  // Controladores dos TextFields
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userSenhaController = TextEditingController();

  final TextEditingController _turmaNomeController = TextEditingController();
  final TextEditingController _funcaoNomeController = TextEditingController();

  // Função para salvar o User
  Future<void> _createUser() async {
    if (_userFormKey.currentState!.validate()) {
      User newUser = User(
        id: '', // O Firestore gerará o ID
        nome: _userNameController.text,
        email: _userEmailController.text,
        senha: _userSenhaController.text,
      );
      await _userService.createUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário criado com sucesso!')));
      _userNameController.clear();
      _userEmailController.clear();
      _userSenhaController.clear();
    }
  }

  // Função para salvar a Turma
  Future<void> _createTurma() async {
    if (_turmaFormKey.currentState!.validate()) {
      Turma newTurma = Turma(
        id: '',
        nome: _turmaNomeController.text,
      );
      await _turmaService.createTurma(newTurma);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Turma criada com sucesso!')));
      _turmaNomeController.clear();
    }
  }

  // Função para salvar a Funcao
  Future<void> _createFuncao() async {
    if (_funcaoFormKey.currentState!.validate()) {
      Funcao newFuncao = Funcao(
        id: '',
        nome: _funcaoNomeController.text,
      );
      await _funcaoService.createFuncao(newFuncao);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Função criada com sucesso!')));
      _funcaoNomeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administração'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Criar Usuário', style: Theme.of(context).textTheme.bodySmall),
            Form(
              key: _userFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(labelText: 'Nome do Usuário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _userEmailController,
                    decoration: InputDecoration(labelText: 'Email do Usuário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _userSenhaController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _createUser,
                    child: Text('Criar Usuário'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Formulário para criar Turma
            Text('Criar Turma', style: Theme.of(context).textTheme.bodyMedium),
            Form(
              key: _turmaFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _turmaNomeController,
                    decoration: InputDecoration(labelText: 'Nome da Turma'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _createTurma,
                    child: Text('Criar Turma'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Formulário para criar Funcao
            Text('Criar Função', style: Theme.of(context).textTheme.bodyLarge),
            Form(
              key: _funcaoFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _funcaoNomeController,
                    decoration: InputDecoration(labelText: 'Nome da Função'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _createFuncao,
                    child: Text('Criar Função'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    _userSenhaController.dispose();
    _turmaNomeController.dispose();
    _funcaoNomeController.dispose();
    super.dispose();
  }
}
