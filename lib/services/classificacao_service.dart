import '../models/selecao.dart';

class ClassificacaoService {
  List<Selecao> ordenarTabela(List<Selecao> selecoes) {
    final copia = List<Selecao>.from(selecoes);
    copia.sort((a, b) {
      if (b.pontos != a.pontos) {
        return b.pontos.compareTo(a.pontos);
      }
      if (b.saldoGols != a.saldoGols) {
        return b.saldoGols.compareTo(a.saldoGols);
      }
      if (b.golsPro != a.golsPro) {
        return b.golsPro.compareTo(a.golsPro);
      }
      final cdPontosA = a.confrontoDiretoPontos[b.nome] ?? 0;
      final cdPontosB = b.confrontoDiretoPontos[a.nome] ?? 0;
      if (cdPontosB != cdPontosA) {
        return cdPontosB.compareTo(cdPontosA);
      }
      final cdSaldoA = a.confrontoDiretoSaldo[b.nome] ?? 0;
      final cdSaldoB = b.confrontoDiretoSaldo[a.nome] ?? 0;
      if (cdSaldoB != cdSaldoA) {
        return cdSaldoB.compareTo(cdSaldoA);
      }
      if (a.pontuacaoCartoes != b.pontuacaoCartoes) {
        return a.pontuacaoCartoes.compareTo(b.pontuacaoCartoes);
      }
      return a.rankingFifa.compareTo(b.rankingFifa);
    });
    return copia;
  }

  String _identificarMotivoDesempate(Selecao atual, Selecao comparada) {
    if (atual.pontos != comparada.pontos) return '';
    if (atual.saldoGols != comparada.saldoGols) {
      return ' <-- Vantagem no Saldo de Gols!';
    }
    if (atual.golsPro != comparada.golsPro) {
      return ' <-- Vantagem em Gols Pró!';
    }
    final cdA = atual.confrontoDiretoPontos[comparada.nome] ?? 0;
    final cdB = comparada.confrontoDiretoPontos[atual.nome] ?? 0;
    if (cdA != cdB) {
      return ' <-- Vantagem no Confronto Direto!';
    }
    if (atual.pontuacaoCartoes != comparada.pontuacaoCartoes) {
      return ' <-- Vantagem no Fair Play (Cartões)!';
    }
    return ' <-- Avança pelo critério de Ranking FIFA!';
  }

  void exibirTabela(List<Selecao> selecoes, {Grupo grupo = Grupo.A}) {
    final ordenada = ordenarTabela(selecoes);

    print('\n=== CLASSIFICAÇÃO GRUPO ${grupo.name} - COPA 2026 ===');
    print(
      '${'Pos'.padRight(4)} | ${'Seleção'.padRight(14)} | ${'Pts'.padRight(3)} | ${'SG'.padRight(4)} | ${'GP'.padRight(3)} | ${'FP'.padRight(3)} | Ranking FIFA',
    );
    print('--------------------------------------------------------------');

    for (int i = 0; i < ordenada.length; i++) {
      final s = ordenada[i];
      final sgFormatado = s.saldoGols > 0 ? '+${s.saldoGols}' : '${s.saldoGols}';
      String obs = '';

      if (i == 2 && ordenada.length >= 3) {
        obs = _identificarMotivoDesempate(s, ordenada[1]);
        if (obs.isEmpty) {
          obs = ' <-- Disputa vaga entre os 8 melhores 3ºs!';
        }
      } else if (i > 0 && s.pontos == ordenada[i - 1].pontos) {
        obs = _identificarMotivoDesempate(s, ordenada[i - 1]);
      }

      print(
        '${'${i + 1}º'.padRight(4)} | ${s.nome.padRight(14)} | ${'${s.pontos}'.padRight(3)} | ${sgFormatado.padRight(4)} | ${'${s.golsPro}'.padRight(3)} | ${'${s.pontuacaoCartoes}'.padRight(3)} | ${s.rankingFifa}º$obs',
      );

      if (i == 1) {
        print(
          '-------------------------------------------------------------- (Zona de Classificação Direta)',
        );
      }
    }
    print('');
  }
}
