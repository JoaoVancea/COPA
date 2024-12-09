import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa/UI/pages/events_page.dart';
import 'package:copa/UI/pages/manage_classes.dart';
import 'package:copa/UI/pages/profile_page.dart';
import 'package:copa/UI/widgets/custom_bottom_navigation_bar.dart';
import 'package:copa/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final AppUser? appUser; // Parâmetro pode ser nulo

  HomePage({super.key, required this.appUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Definir páginas com base na condição do appUser
    if (widget.appUser != null) {
      _pages = widget.appUser!.isAdmin
          ? [
              HomeContent(),
              ManageClasses(),
              EventsPage(
                appUser: widget.appUser!,
              ),
              ProfilePage(appUser: widget.appUser!),
            ]
          : [
              HomeContent(),
              EventsPage(
                appUser: widget.appUser!,
              ),
              ProfilePage(appUser: widget.appUser!),
            ];
    } else {
      // Usuário convidado
      _pages = [
        HomeContent(),
        ProfilePage(appUser: widget.appUser), // Página para usuários anônimos
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isAdmin: widget.appUser?.isAdmin, // Pode ser nulo
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Map<String, int> turmasPontuacao = {};
  Map<String, String> turmasSigla = {}; // Mapa de turmaId para sigla

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Função para buscar os dados das turmas e eventos
  Future<void> _fetchData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Buscar turmas
  QuerySnapshot turmasSnapshot = await firestore.collection('turmas').get();
  Map<String, String> siglas = {};

  // Mapear o ID da turma para a sua sigla
  for (var doc in turmasSnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    String turmaId = doc.id;
    String sigla = data['sigla'] ?? '';
    siglas[turmaId] = sigla;
  }

  // Buscar eventos
  QuerySnapshot eventosSnapshot = await firestore.collection('evento').get();
  Map<String, int> somaPontuacao = {};

  // Iterar sobre cada documento da coleção 'evento'
  for (var doc in eventosSnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;

    String turmaId = data['turmaId'];
    int valor = data['valor'];

    // Somar valores apenas se forem positivos
    if (valor > 0) {
      if (somaPontuacao.containsKey(turmaId)) {
        somaPontuacao[turmaId] = somaPontuacao[turmaId]! + valor;
      } else {
        somaPontuacao[turmaId] = valor;
      }
    }
  }

  // Certificar-se de que todas as turmas estão presentes no mapa de pontuações (mesmo com 0 pontos)
  siglas.forEach((turmaId, sigla) {
    if (!somaPontuacao.containsKey(turmaId)) {
      somaPontuacao[turmaId] = 0;
    }
  });

  // Verificar se o widget ainda está montado antes de chamar setState
  if (mounted) {
    setState(() {
      turmasSigla = siglas; // Mapear ID -> Sigla
      turmasPontuacao = somaPontuacao; // Mapear ID -> Pontuação
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 280,
                decoration: const BoxDecoration(
                  color: Color(0xFF4960F9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                              child: SvgPicture.asset('logoCopa.svg')),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset('defaultAvatar.jpg',
                                  width: 65, height: 65)),
                        ],
                      ),
                      Text(
                        'Seja Bem vindo!',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 230, 20, 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Pontuação Geral',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Gráfico Vertical (Pódio)
                            if (turmasPontuacao.isNotEmpty) _buildPodium(),
                            const SizedBox(height: 30),
                            // Gráfico Horizontal (Ranking Geral)
                            if (turmasPontuacao.isNotEmpty)
                              _buildRankingList(turmasPontuacao),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Função para construir o pódio (gráfico vertical)
  Widget _buildPodium() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPodiumColumn(
          '2º',
          _getSiglaTurma(turmasPontuacao, 2),
          _getValorTurma(turmasPontuacao, 2),
          2,
          const Color(0xFFB52FF8), // Segundo lugar - roxo
        ),
        _buildPodiumColumn(
          '1º',
          _getSiglaTurma(turmasPontuacao, 1),
          _getValorTurma(turmasPontuacao, 1),
          1,
          const Color(0xFF2B47FC), // Primeiro lugar - azul
        ),
        _buildPodiumColumn(
          '3º',
          _getSiglaTurma(turmasPontuacao, 3),
          _getValorTurma(turmasPontuacao, 3),
          3,
          const Color(0xFFB52FF8), // Terceiro lugar - roxo
        ),
      ],
    );
  }

  // Função para construir as colunas do pódio
  Widget _buildPodiumColumn(String posicao, String siglaTurma, int valor,
      int posicaoInt, Color color) {
    double altura;
    switch (posicaoInt) {
      case 1:
        altura = 150;
        break;
      case 2:
        altura = 120;
        break;
      case 3:
        altura = 100;
        break;
      default:
        altura = 100;
    }
    return Column(
      children: [
        Text(
          posicao, // Exibe a posição (1º, 2º, 3º)
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: altura,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              valor.toString(),
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          siglaTurma,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Função para construir a lista de rankings (gráfico horizontal)
  Widget _buildRankingList(Map<String, int> turmas) {
    // Obter o tamanho da tela do usuário
    double screenWidth = MediaQuery.of(context).size.width;

    // Espaço reservado para o texto à direita
    const double espacoTexto = 40;

    // Definir tamanho mínimo e máximo para as barras
    const double tamanhoMinimo = 40;
    final double tamanhoMaximo = screenWidth * 0.7 - espacoTexto;

    // Ordenar as turmas pela pontuação
    List<MapEntry<String, int>> sortedTurmas = turmas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Encontrar o maior valor para escalar proporcionalmente
    int maiorValor = sortedTurmas.first.value;

    return Column(
      children: List.generate(sortedTurmas.length, (index) {
        String turmaId = sortedTurmas[index].key;
        int valor = sortedTurmas[index].value;
        String sigla = turmasSigla[turmaId] ?? 'N/A';

        // Definir a largura da barra proporcional ao maior valor, limitando ao tamanho máximo da tela
        double larguraBarra = (valor / maiorValor) * tamanhoMaximo;
        if (larguraBarra < tamanhoMinimo) {
          larguraBarra = tamanhoMinimo; // Aplicar o tamanho mínimo
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Posição da turma
              Text(
                '${index + 1}º',
                style: GoogleFonts.montserrat(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              // Barra de pontuação
              Stack(
                children: [
                  Container(
                    width: larguraBarra, // Largura proporcional à pontuação
                    height: 32, // Ajustar altura da barra
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(
                              0xFF2B47FC) // Primeiro lugar - cor diferenciada
                          : const Color(
                              0xFFB52FF8), // Outros lugares - cor padrão
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 8, // Centralizar o texto verticalmente
                    child: Text(
                      valor.toString(),
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // Sigla da turma
              Text(
                sigla,
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Função para buscar a sigla da turma baseado na posição
  String _getSiglaTurma(Map<String, int> turmas, int posicao) {
    List<MapEntry<String, int>> sortedTurmas = turmas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    String turmaId =
        sortedTurmas.length >= posicao ? sortedTurmas[posicao - 1].key : "N/A";

    // Retornar a sigla correspondente ao turmaId
    return turmasSigla.containsKey(turmaId) ? turmasSigla[turmaId]! : "N/A";
  }

  // Função para buscar o valor da turma baseado na posição
  int _getValorTurma(Map<String, int> turmas, int posicao) {
    List<MapEntry<String, int>> sortedTurmas = turmas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedTurmas.length >= posicao ? sortedTurmas[posicao - 1].value : 0;
  }
}
