import 'dart:convert';
import 'dart:io';
import '../models/selecao.dart';

class DadosService {
  Future<List<Selecao>> carregarSelecoes({
    String caminhoArquivo = 'dados_copa.json',
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final file = File(caminhoArquivo);
    if (!await file.exists()) {
      throw FileSystemException(
        'Arquivo JSON da Copa 2026 não encontrado.',
        caminhoArquivo,
      );
    }

    final conteudo = await file.readAsString();
    final Map<String, dynamic> jsonMap =
        jsonDecode(conteudo) as Map<String, dynamic>;
    final List<dynamic> lista = jsonMap['selecoes'] as List<dynamic>;

    return lista
        .map((item) => Selecao.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static int lerInteiroValidado(
    String prompt, {
    String mensagemErro = 'Erro: Digite um placar válido!',
    String? Function()? leitor,
  }) {
    final readFn = leitor ?? stdin.readLineSync;
    while (true) {
      stdout.write(prompt);
      final entrada = (readFn() ?? '').trim();
      try {
        final valor = int.parse(entrada);
        if (valor < 0) {
          throw const FormatException('Valor negativo não permitido');
        }
        return valor;
      } on FormatException {
        print(mensagemErro);
      }
    }
  }
}
