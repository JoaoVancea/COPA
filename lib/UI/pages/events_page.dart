import 'package:copa/UI/pages/avaliar_eventos.dart';
import 'package:copa/UI/pages/create_event.dart';
import 'package:copa/UI/pages/detalhes_evento.dart';
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
                    Row(
                      children: [
                        SvgPicture.asset('search.svg'),
                        const SizedBox(width: 8),
                        if (widget.appUser.isAdmin)
                          const SizedBox.shrink()
                        else
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateEvent(
                                          appUser: widget.appUser)));
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
        _buildTabBar(), 
        Expanded(
          child: selectedTabIndex == 0
              ? _buildNaoAvaliadoEvents()
              : _buildAvaliadoEvents(),
        ),
      ],
    );
  }

  Widget _buildUserView() {
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('evento')
        .where('user', isEqualTo: widget.appUser.id) // Filtra pelo ID do usuário
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final events = snapshot.data!.docs;

      if (events.isEmpty) {
        return const Center(child: Text("Nenhum evento publicado."));
      }

      // Ordena os eventos para que os "em andamento" (valor == 0) fiquem no topo
      events.sort((a, b) {
        final int valorA = a['valor'];
        final int valorB = b['valor'];

        // Coloca os eventos com valor 0 (em andamento) no topo
        if (valorA == 0 && valorB != 0) {
          return -1; // Evento "em andamento" vem primeiro
        } else if (valorA != 0 && valorB == 0) {
          return 1; // Evento já avaliado vem depois
        }
        return 0; // Deixa os demais eventos na ordem original
      });

      return _buildEventList(events,
          isUser: true); // Usa a função existente para exibir os eventos
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
                selectedTabIndex = 0; 
              });
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Não Avaliados",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedTabIndex == 0
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  color: selectedTabIndex == 0 ? Colors.blue : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 1,
          color: Colors.grey.shade300, 
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTabIndex = 1; 
              });
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Avaliados",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedTabIndex == 1
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  color: selectedTabIndex == 1 ? Colors.blue : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildAvaliadoEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('evento')
          .where('valor',
              isNotEqualTo: 0) // Eventos com valor != 0 (aceitos e negados)
          .orderBy('dataCriacao',
              descending: true) // Ordena pelos mais recentes
          .snapshots(),
      builder: (context, snapshot) {
        // Verifique se o stream ainda está ativo ou se os dados estão completos
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Imprime o erro no console para depuração
          print("Erro ao carregar eventos: ${snapshot.error}");
          return const Center(child: Text("Erro ao carregar eventos."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Nenhum evento avaliado."));
        }

        final events = snapshot.data!.docs;

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
          return const Center(child: Text("Nenhum evento para avaliar."));
        }

        return _buildEventList(events, isUser: false);
      },
    );
  }

 
 Widget _buildEventList(List<QueryDocumentSnapshot> events,
    {required bool isUser}) {
  return ListView.builder(
    itemCount: events.length,
    itemBuilder: (context, index) {
      final event = events[index];
      final titulo = event['titulo'];
      final descricao = event['descricao'];
      final int valor = event['valor']; // Pontuação do evento
      final String eventoId = event.id; // ID do evento para navegação
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
        child: GestureDetector(
          onTap: () {
            // Redirecionamento baseado no estado do evento
            if (valor != 0 || isUser) {
              // Eventos avaliados ou eventos do representante vão para a tela de detalhes
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesEventoPage(eventoId: eventoId),
                ),
              );
            } else if (widget.appUser.isAdmin && valor == 0) {
              // Eventos pendentes de avaliação para Admin
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AvaliarEventoPage(
                    eventoId: eventoId,
                    appUser: widget.appUser,
                  ),
                ),
              );
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.appUser.imgUser,
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
                  if (!isUser && valor != 0) ...[
                    const SizedBox(height: 8),
                    if (valor == -1)
                      Text(
                        'Evento negado',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    else
                      Text(
                        'Pontuação: $valor',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
        ),
      );
    },
  );
}

}
