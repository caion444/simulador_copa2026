enum Grupo { A, B, C, D, E, F, G, H, I, J, K, L }

class Selecao {
  final String nome;
  final Grupo grupo;
  final int rankingFifa;

  int pontos;
  int golsPro;
  int golsSofridos;
  int cartoesAmarelos;
  int cartoesVermelhos;

  final Map<String, int> confrontoDiretoPontos = {};
  final Map<String, int> confrontoDiretoSaldo = {};

  Selecao({
    required this.nome,
    required this.grupo,
    required this.rankingFifa,
    this.pontos = 0,
    this.golsPro = 0,
    this.golsSofridos = 0,
    this.cartoesAmarelos = 0,
    this.cartoesVermelhos = 0,
  });

  int get saldoGols => golsPro - golsSofridos;

  int get pontuacaoCartoes => cartoesAmarelos + (cartoesVermelhos * 3);

  factory Selecao.fromJson(Map<String, dynamic> json) {
    final grupoStr = (json['grupo'] as String? ?? 'A').toUpperCase();
    final grupoEnum = Grupo.values.firstWhere(
      (g) => g.name == grupoStr,
      orElse: () => Grupo.A,
    );

    return Selecao(
      nome: json['nome'] as String,
      grupo: grupoEnum,
      rankingFifa: (json['rankingFifa'] as num).toInt(),
    );
  }
}
