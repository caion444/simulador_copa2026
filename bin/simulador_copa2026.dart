import 'dart:io';
import 'package:simulador_copa2026/models/selecao.dart';
import 'package:simulador_copa2026/services/classificacao_service.dart';
import 'package:simulador_copa2026/services/dados_service.dart';
import 'package:simulador_copa2026/services/gerenciador_partidas.dart';

Future<void> main(List<String> arguments) async {
  final dadosService = DadosService();
  final gerenciador = GerenciadorPartidas();
  final classificacao = ClassificacaoService();

  print('Carregando dados oficiais da Copa do Mundo 2026...');
  late List<Selecao> selecoes;
  try {
    selecoes = await dadosService.carregarSelecoes();
  } catch (e) {
    print('Erro ao carregar dados_copa.json: $e');
    exit(1);
  }

  if (arguments.contains('--demo')) {
    gerenciador.aplicarResultado(timeA: selecoes[0], timeB: selecoes[3], golsA: 3, golsB: 0);
    gerenciador.aplicarResultado(timeA: selecoes[0], timeB: selecoes[1], golsA: 1, golsB: 1);
    gerenciador.aplicarResultado(timeA: selecoes[0], timeB: selecoes[2], golsA: 1, golsB: 0);
    gerenciador.aplicarResultado(timeA: selecoes[1], timeB: selecoes[2], golsA: 0, golsB: 0);
    gerenciador.aplicarResultado(timeA: selecoes[1], timeB: selecoes[3], golsA: 1, golsB: 1);
    gerenciador.aplicarResultado(timeA: selecoes[2], timeB: selecoes[3], golsA: 2, golsB: 1);
    classificacao.exibirTabela(selecoes, grupo: selecoes.first.grupo);
    return;
  }

  while (true) {
    print('=== SIMULADOR GRUPO ${selecoes.first.grupo.name} - COPA 2026 ===');
    print('1. Registrar Resultado de Jogo');
    print('2. Ver Classificação Atual');
    print('3. Sair');
    stdout.write('Opção: ');
    final opcao = (stdin.readLineSync() ?? '').trim();

    if (opcao == '1') {
      print('\nSelecione as seleções da partida:');
      for (int i = 0; i < selecoes.length; i++) {
        print('${i + 1}. ${selecoes[i].nome}');
      }
      final idxA = DadosService.lerInteiroValidado(
            'Número da Seleção A (1-${selecoes.length}): ',
            mensagemErro: 'Erro: Selecione uma seleção válida!',
          ) -
          1;
      final idxB = DadosService.lerInteiroValidado(
            'Número da Seleção B (1-${selecoes.length}): ',
            mensagemErro: 'Erro: Selecione uma seleção válida!',
          ) -
          1;

      if (idxA < 0 ||
          idxA >= selecoes.length ||
          idxB < 0 ||
          idxB >= selecoes.length ||
          idxA == idxB) {
        print('Erro: Escolha duas seleções diferentes e válidas!\n');
        continue;
      }

      gerenciador.registrarJogo(selecoes[idxA], selecoes[idxB]);
      print('');
    } else if (opcao == '2') {
      classificacao.exibirTabela(selecoes, grupo: selecoes.first.grupo);
    } else if (opcao == '3') {
      print('Encerrando Simulador da Copa 2026. Até o próximo semestre!');
      break;
    } else {
      print('Opção inválida. Escolha 1, 2 ou 3.\n');
    }
  }
}
