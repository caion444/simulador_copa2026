import 'package:test/test.dart';
import 'package:simulador_copa2026/models/selecao.dart';
import 'package:simulador_copa2026/services/classificacao_service.dart';
import 'package:simulador_copa2026/services/dados_service.dart';
import 'package:simulador_copa2026/services/gerenciador_partidas.dart';

void main() {
  test('Carrega selecoes do arquivo dados_copa.json de forma assincrona', () async {
    final service = DadosService();
    final selecoes = await service.carregarSelecoes();
    expect(selecoes.length, 4);
    expect(selecoes.first.nome, 'México');
    expect(selecoes.first.grupo, Grupo.A);
  });

  test('Valida criterios de desempate Copa 2026 incluindo Ranking FIFA', () {
    final gerenciador = GerenciadorPartidas();
    final classificacao = ClassificacaoService();

    final mexico = Selecao(nome: 'México', grupo: Grupo.A, rankingFifa: 15);
    final africaSul = Selecao(nome: 'África do Sul', grupo: Grupo.A, rankingFifa: 59);
    final repCheca = Selecao(nome: 'Rep. Checa', grupo: Grupo.A, rankingFifa: 36);
    final coreiaSul = Selecao(nome: 'Coreia do Sul', grupo: Grupo.A, rankingFifa: 22);

    gerenciador.aplicarResultado(timeA: mexico, timeB: coreiaSul, golsA: 4, golsB: 0);
    gerenciador.aplicarResultado(timeA: mexico, timeB: africaSul, golsA: 1, golsB: 1);
    gerenciador.aplicarResultado(timeA: mexico, timeB: repCheca, golsA: 1, golsB: 1);
    gerenciador.aplicarResultado(timeA: africaSul, timeB: repCheca, golsA: 1, golsB: 1);
    gerenciador.aplicarResultado(timeA: africaSul, timeB: coreiaSul, golsA: 0, golsB: 0);
    gerenciador.aplicarResultado(timeA: repCheca, timeB: coreiaSul, golsA: 0, golsB: 0);

    final tabela = classificacao.ordenarTabela([mexico, africaSul, repCheca, coreiaSul]);
    expect(tabela[0].nome, 'México');
    expect(tabela[1].nome, 'Rep. Checa');
    expect(tabela[2].nome, 'África do Sul');
    expect(tabela[3].nome, 'Coreia do Sul');
  });

  test('Trata entrada invalida com try-catch e exibe mensagem padrao', () {
    final entradas = ['abc', '-2', '3'];
    int idx = 0;
    final resultado = DadosService.lerInteiroValidado(
      'Placar: ',
      leitor: () => entradas[idx++],
    );
    expect(resultado, 3);
  });
}
