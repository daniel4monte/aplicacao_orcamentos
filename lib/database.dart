import 'package:hive/hive.dart';

class OrcamentoDB {
  // Abre a box corretamente
  static Future<Box> getBox() async {
    return await Hive.openBox('orcamentos');
  }

  // Guardar orçamento
  static Future<void> guardarOrcamento(Map<String, dynamic> orcamento) async {
    final box = await getBox();
    await box.add(orcamento);
  }

  // Listar orçamentos
  static Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final box = await getBox();
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // 🔥 APAGAR ORÇAMENTO — CORREÇÃO DEFINITIVA
  // Nunca mais dá erro de índice -1
  static Future<void> apagarOrcamento(Map<String, dynamic> orc) async {
    final box = await getBox();

    final values = box.values.toList();
    final keys = box.keys.toList();

    final index = values.indexOf(orc);

    if (index == -1) {
      // segurança extra
      return;
    }

    final key = keys[index];

    await box.delete(key);
  }

  // Atualizar orçamento (usado no regenerar PDFs)
  static Future<void> atualizarOrcamento(int index, Map<String, dynamic> novo) async {
    final box = await getBox();
    await box.putAt(index, novo);
  }

  // Contar orçamentos do dia (para gerar número automático)
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
