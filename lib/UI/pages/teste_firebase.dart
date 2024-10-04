import 'package:copa/features/funcao/model/funcao_model.dart';
import 'package:copa/features/funcao/services/funcao_service.dart';
import 'package:copa/features/turma/model/turma_model.dart';
import 'package:copa/features/turma/services/turma_service.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:copa/features/user/services/user_service.dart';
import 'package:copa/features/userTurma/model/user_turma_model.dart';
import 'package:copa/features/userTurma/services/user_turma_service.dart';
import 'package:flutter/material.dart';

class UserTurmaPage extends StatefulWidget {
  @override
  _UserTurmaPageState createState() => _UserTurmaPageState();
}

class _UserTurmaPageState extends State<UserTurmaPage> {
  String? selectedUserId;
  String? selectedTurmaId;
  String? selectedFuncaoId;
  bool _userTurmaStatus = false;

  final UserService userService = UserService();
  final TurmaService turmaService = TurmaService();
  final FuncaoService funcaoService = FuncaoService();
  final UserTurmaService userTurmaService = UserTurmaService();

  void _submitUserTurma() async {
    if (selectedUserId != null && selectedTurmaId != null && selectedFuncaoId != null) {
      final newUserTurma = UserTurma(
        id: '',
        userId: selectedUserId!,
        turmaId: selectedTurmaId!,
        funcaoId: selectedFuncaoId!,
        status: _userTurmaStatus,
      );

      await userTurmaService.createUserTurma(newUserTurma);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário vinculado à Turma com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  Widget _buildUserDropdown() {
    return FutureBuilder<List<User>>(
      future: userService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhum usuário encontrado');
        }
        return DropdownButton<String>(
          hint: Text('Selecione um Usuário'),
          value: selectedUserId,
          onChanged: (value) {
            setState(() {
              selectedUserId = value;
            });
          },
          items: snapshot.data!.map((user) {
            return DropdownMenuItem<String>(
              value: user.id,
              child: Text(user.nome),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTurmaDropdown() {
    return FutureBuilder<List<Turma>>(
      future: turmaService.getTurmas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhuma turma encontrada');
        }
        return DropdownButton<String>(
          hint: Text('Selecione uma Turma'),
          value: selectedTurmaId,
          onChanged: (value) {
            setState(() {
              selectedTurmaId = value;
            });
          },
          items: snapshot.data!.map((turma) {
            return DropdownMenuItem<String>(
              value: turma.id,
              child: Text(turma.nome),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFuncaoDropdown() {
    return FutureBuilder<List<Funcao>>(
      future: funcaoService.getFuncoes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhuma função encontrada');
        }
        return DropdownButton<String>(
          hint: Text('Selecione uma Função'),
          value: selectedFuncaoId,
          onChanged: (value) {
            setState(() {
              selectedFuncaoId = value;
            });
          },
          items: snapshot.data!.map((funcao) {
            return DropdownMenuItem<String>(
              value: funcao.id,
              child: Text(funcao.nome),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vincular Usuário à Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecione o Usuário', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildUserDropdown(),
            SizedBox(height: 20),
            Text('Selecione a Turma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildTurmaDropdown(),
            SizedBox(height: 20),
            Text('Selecione a Função', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildFuncaoDropdown(),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Ativo'),
                Switch(
                  value: _userTurmaStatus,
                  onChanged: (value) {
                    setState(() {
                      _userTurmaStatus = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitUserTurma,
              child: Text('Vincular Usuário à Turma'),
            ),
          ],
        ),
      ),
    );
  }
}
