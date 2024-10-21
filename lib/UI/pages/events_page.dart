import 'package:copa/features/user/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsPage extends StatefulWidget {
  final AppUser appUser; // Contém os dados do usuário logado
  EventsPage({super.key, required this.appUser});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 110),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0xFF40CEF2)),
            ),
            Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4960F9), Color(0xFF1937FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('chat.svg'),
                    SvgPicture.asset('search.svg'),
                    if (widget.appUser.isAdmin)
                      const SizedBox.shrink()
                    else
                      GestureDetector(
                        onTap: () {
                          // Aqui você pode navegar para criar um evento
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: widget.appUser.isAdmin ? _buildAdminView() : _buildUserView(),
    );
  }

  // Interface do Admin
  Widget _buildAdminView() {
    return Column(
      children: [
        _buildTabBar(), // Mostra as abas "Avaliados" e "Não Avaliados" para o Admin
        Expanded(
          child: selectedTabIndex == 0
              ? _buildAvaliadoEvents()
              : _buildNaoAvaliadoEvents(),
        ),
      ],
    );
  }

  // Interface do usuário normal
  Widget _buildUserView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('evento')
          .where('user', isEqualTo: widget.appUser.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        if (events.isEmpty) {
          return const Center(child: Text("Nenhum evento publicado."));
        }

        return _buildEventList(events, isUser: true);
      },
    );
  }

  // Abas para o admin
  Widget _buildTabBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTabIndex =
                    0; // Exibe eventos avaliados (aceitos e negados)
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: selectedTabIndex == 0
                  ? const Color(0xFF4960F9)
                  : Colors.transparent,
              child: Center(
                child: Text(
                  "Avaliados",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedTabIndex == 0 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTabIndex = 1; // Exibe eventos não avaliados (pendentes)
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: selectedTabIndex == 1
                  ? const Color(0xFF4960F9)
                  : Colors.transparent,
              child: Center(
                child: Text(
                  "Não Avaliados",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedTabIndex == 1 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Mostra eventos avaliados para o Admin
  Widget _buildAvaliadoEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('evento')
          .where('valor',
              isNotEqualTo: 0) // Eventos com valor != 0 (aceitos e negados)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        if (events.isEmpty) {
          return const Center(child: Text("Nenhum evento avaliado."));
        }

        return _buildEventList(events, isUser: false);
      },
    );
  }

  // Mostra eventos não avaliados (pendentes) para o Admin
  Widget _buildNaoAvaliadoEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('evento')
          .where('valor', isEqualTo: 0)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        if (events.isEmpty) {
          return const Center(child: Text("Nenhum evento não avaliado."));
        }

        return _buildEventList(events, isUser: false);
      },
    );
  }

  // Função genérica para exibir os eventos (tanto para admin quanto usuário)
  Widget _buildEventList(List<QueryDocumentSnapshot> events,
      {required bool isUser}) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final titulo = event['titulo'];
        final descricao = event['descricao'];
        final int valor = event['valor'];
        final Timestamp? timestamp = event['dataCriacao'] as Timestamp?;
        DateTime? date = timestamp != null ? timestamp.toDate() : null;

        // Define o status baseado no valor (apenas para usuários normais)
        String status = '';
        Color statusColor = Colors.transparent;

        if (isUser) {
          if (valor > 0) {
            status = "Aceito com pontuação: $valor";
            statusColor = Colors.green;
          } else if (valor == -1) {
            status = "Negado";
            statusColor = Colors.red;
          } else {
            status = "Em andamento";
            statusColor = Colors.orange;
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.appUser.imgUser, // Usa a imagem do aluno
                ),
                radius: 25,
              ),
              title: Text(
                titulo,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descricao,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  if (isUser) ...[
                    const SizedBox(height: 8),
                    Text(
                      status,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: date != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${date.day}/${date.month.toString().padLeft(2, '0')}',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      "Sem data",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
