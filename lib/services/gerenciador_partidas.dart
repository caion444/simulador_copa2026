import '../models/selecao.dart';
import 'dados_service.dart';

class GerenciadorPartidas {
  final List<String> historicoJogos = [];

  void aplicarResultado({
    required Selecao timeA,
    required Selecao timeB,
    required int golsA,
    required int golsB,
    int amarelosA = 0,
    int vermelhosA = 0,
    int amarelosB = 0,
    int vermelhosB = 0,
  }) {
    timeA.golsPro += golsA;
    timeA.golsSofridos += golsB;
    timeA.cartoesAmarelos += amarelosA;
    timeA.cartoesVermelhos += vermelhosA;

    timeB.golsPro += golsB;
    timeB.golsSofridos += golsA;
    timeB.cartoesAmarelos += amarelosB;
    timeB.cartoesVermelhos += vermelhosB;

    final saldoA = golsA - golsB;
    final saldoB = golsB - golsA;

    timeA.confrontoDiretoSaldo[timeB.nome] =
        (timeA.confrontoDiretoSaldo[timeB.nome] ?? 0) + saldoA;
    timeB.confrontoDiretoSaldo[timeA.nome] =
        (timeB.confrontoDiretoSaldo[timeA.nome] ?? 0) + saldoB;

    if (golsA > golsB) {
      timeA.pontos += 3;
      timeA.confrontoDiretoPontos[timeB.nome] =
          (timeA.confrontoDiretoPontos[timeB.nome] ?? 0) + 3;
    } else if (golsB > golsA) {
      timeB.pontos += 3;
      timeB.confrontoDiretoPontos[timeA.nome] =
          (timeB.confrontoDiretoPontos[timeA.nome] ?? 0) + 3;
    } else {
      timeA.pontos += 1;
      timeB.pontos += 1;
      timeA.confrontoDiretoPontos[timeB.nome] =
          (timeA.confrontoDiretoPontos[timeB.nome] ?? 0) + 1;
      timeB.confrontoDiretoPontos[timeA.nome] =
          (timeB.confrontoDiretoPontos[timeA.nome] ?? 0) + 1;
    }

    historicoJogos.add('${timeA.nome} $golsA x $golsB ${timeB.nome}');
  }

  void registrarJogo(Selecao timeA, Selecao timeB) {
    print('\n--- REGISTRO DE PARTIDA: ${timeA.nome} x ${timeB.nome} ---');
    final golsA = DadosService.lerInteiroValidado(
      'Gols de ${timeA.nome}: ',
      mensagemErro: 'Erro: Digite um placar válido!',
    );
    final golsB = DadosService.lerInteiroValidado(
      'Gols de ${timeB.nome}: ',
      mensagemErro: 'Erro: Digite um placar válido!',
    );
    final amarelosA = DadosService.lerInteiroValidado(
      'Cartões amarelos de ${timeA.nome}: ',
      mensagemErro: 'Erro: Digite uma quantidade de cartões válida!',
    );
    final vermelhosA = DadosService.lerInteiroValidado(
      'Cartões vermelhos de ${timeA.nome}: ',
      mensagemErro: 'Erro: Digite uma quantidade de cartões válida!',
    );
    final amarelosB = DadosService.lerInteiroValidado(
      'Cartões amarelos de ${timeB.nome}: ',
      mensagemErro: 'Erro: Digite uma quantidade de cartões válida!',
    );
    final vermelhosB = DadosService.lerInteiroValidado(
      'Cartões vermelhos de ${timeB.nome}: ',
      mensagemErro: 'Erro: Digite uma quantidade de cartões válida!',
    );

    aplicarResultado(
      timeA: timeA,
      timeB: timeB,
      golsA: golsA,
      golsB: golsB,
      amarelosA: amarelosA,
      vermelhosA: vermelhosA,
      amarelosB: amarelosB,
      vermelhosB: vermelhosB,
    );

    print(
      'Placar registrado: ${timeA.nome} $golsA x $golsB ${timeB.nome}!',
    );
  }
}
