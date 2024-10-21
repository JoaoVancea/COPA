import 'package:copa/UI/pages/change_password.dart';
import 'package:copa/UI/pages/create_user.dart';
import 'package:copa/UI/pages/edit_user.dart';
import 'package:copa/UI/pages/home_page.dart';
import 'package:copa/UI/pages/login_page.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final AppUser? appUser; // Aceita null agora

  ProfilePage({super.key, required this.appUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AppUser appUser;
  late String userPhotoUrl;
  late String userNome;
  final FirebaseAuth _authService = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Verificar se appUser é null, caso contrário usar valores padrão
    appUser = widget.appUser ??
        AppUser(
          id: 'anonymous',
          nome: 'Convidado',
          email: '',
          imgUser:
              'https://firebasestorage.googleapis.com/v0/b/copa-e8ad2.appspot.com/o/defaultAvatar.jpg?alt=media&token=6a416dae-2cf2-4f07-8654-127d9b771628', // Placeholder de imagem
          isAdmin: false,
        );
    userPhotoUrl = appUser.imgUser;
    userNome = appUser.nome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset('profilePage.svg')),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 90, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perfil',
                      style: GoogleFonts.montserrat(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(userPhotoUrl,
                                width: 65, height: 65)),
                        const SizedBox(width: 12),
                        Text(userNome,
                            style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF2743FD)))
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildUserInfoSection(),
                  ],
                ),
              ),
            ],
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    // Verificar se appUser é null antes de acessar isAdmin
    if (widget.appUser == null || widget.appUser!.id == 'anonymous') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text('Tipo de Conta', style: GoogleFonts.roboto(fontSize: 14)),
          const SizedBox(height: 15),
          Text('Convidado',
              style: GoogleFonts.aBeeZee(
                  fontSize: 14, color: const Color(0xFF2743FD))),
          const SizedBox(height: 50),
        ],
      );
    } else {
      if (widget.appUser != null && widget.appUser!.isAdmin) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Função', style: GoogleFonts.roboto(fontSize: 14)),
            const SizedBox(height: 15),
            Text('Professor',
                style: GoogleFonts.aBeeZee(
                    fontSize: 14, color: const Color(0xFF2743FD))),
            const SizedBox(height: 15),
            Text('Tipo de Conta', style: GoogleFonts.roboto(fontSize: 14)),
            const SizedBox(height: 15),
            Text('Administrador',
                style: GoogleFonts.aBeeZee(
                    fontSize: 14, color: const Color(0xFF2743FD))),
            const SizedBox(height: 50),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Função', style: GoogleFonts.roboto(fontSize: 14)),
            const SizedBox(height: 15),
            Text('Representante',
                style: GoogleFonts.aBeeZee(
                    fontSize: 14, color: const Color(0xFF2743FD))),
            const SizedBox(height: 35)
          ],
        );
      }
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    if (widget.appUser == null || widget.appUser!.id == 'anonymous') {
      return Center(
        child: Column(
          children: [
            _buildFullWidthButton(
              label: 'Conectar',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon:
                  const Icon(Icons.logout, color: Color(0xFF2743FD), size: 25),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  label: 'Editar Perfil',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUser(appUser: appUser),
                      ),
                    ).then((result) {
                      if (result == true) {
                        // Atualize os dados do usuário aqui
                        setState(() {
                          userNome = appUser
                              .nome; // Atualize o nome ou outros detalhes aqui
                        });
                      }
                    });
                  },
                  width: 150, // Definir a largura do botão
                ),
                const SizedBox(width: 15),
                _buildActionButton(
                  label: 'Criar usuário',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateUser()));
                  },
                  width: 150, // Definir a largura do botão
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFullWidthButton(
              label: 'Mudar Senha',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
            ),
            const SizedBox(height: 16),
            _buildFullWidthButton(
              label: 'Desconectar',
              onPressed: () {
                _logoutConfirmation(context);
              },
              icon:
                  const Icon(Icons.logout, color: Color(0xFF2743FD), size: 25),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActionButton(
      {required String label,
      required VoidCallback onPressed,
      double width = 151}) {
    return Container(
      height: 56,
      width: width, // Use a largura passada por parâmetro
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF2743FD), width: 1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              color: const Color(0xFF2743FD),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(
      {required String label, required VoidCallback onPressed, Widget? icon}) {
    return Container(
      height: 56,
      width: 315,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF2743FD), width: 1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: const Color(0xFF2743FD),
                ),
              ),
              if (icon != null) icon,
            ],
          ),
        ),
      ),
    );
  }
}

void _logoutConfirmation(BuildContext context) {
  FirebaseAuth _auth = FirebaseAuth.instance;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            SvgPicture.asset('logoutConfirmation.svg'),
            const SizedBox(height: 24),
            Text(
              'Tem Certeza?',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLogoutButton(context, 'Sim', () async {
                  // Adicionar funcionalidade de logout
                  await _auth.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(appUser: null)));
                }),
                _buildLogoutButton(context, 'Não', () {
                  Navigator.of(context).pop();
                }),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildLogoutButton(
    BuildContext context, String label, VoidCallback onPressed) {
  return Container(
    height: 40,
    width: 88,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white),
      ),
    ),
  );
}
