import 'package:hive/hive.dart';

class OrcamentoDB {
  // 🔓 MÉTODO PÚBLICO PARA ABRIR A BOX
  static Future<Box> getBox() async {
    return await Hive.openBox('orcamentos');
  }

  static Future<void> guardarOrcamento(Map<String, dynamic> orcamento) async {
    final box = await getBox();
    await box.add(orcamento);
  }

  static Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final box = await getBox();
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> apagarOrcamento(int index) async {
    final box = await getBox();
    await box.deleteAt(index);
  }

  // 🔧 MÉTODO PARA ATUALIZAR ORÇAMENTO (necessário para regenerar PDFs)
  static Future<void> atualizarOrcamento(int index, Map<String, dynamic> novo) async {
    final box = await getBox();
    await box.putAt(index, novo);
  }

  // 🔢 CONTAR ORÇAMENTOS DO DIA (para gerar ORC-dia-mes-ano-numero)
  static Future<int> contarOrcamentosDoDia(String dia, String mes, String ano) async {
    final box = await getBox();
    int count = 0;

    for (var e in box.values) {
      final data = DateTime.parse(e["data"]);
      if (data.day.toString() == dia &&
          data.month.toString() == mes &&
          data.year.toString() == ano) {
        count++;
      }
    }

    return count;
  }
}
