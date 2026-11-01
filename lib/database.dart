import 'package:hive/hive.dart';

class OrcamentoDB {
  // Abre a box corretamente
  static Future<Box> getBox() async {
    return await Hive.openBox('orcamentos');
  }

  // Guardar orçamento
  static Future<void> guardarOrcamento(Map<String, dynamic> orcamento) async {
    final box = await getBox();

    // Estado inicial
    orcamento["estado"] = orcamento["estado"] ?? "pendente";

    await box.add(orcamento);
  }

  // Listar orçamentos
  static Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final box = await getBox();

    return box.values.map((e) {
      final Map<String, dynamic> orc = Map<String, dynamic>.from(e as Map);

      // Converter cliente
      orc["cliente"] = Map<String, dynamic>.from((orc["cliente"] ?? {}) as Map);

      // Converter lista de serviços
      orc["servicos"] = (orc["servicos"] as List? ?? []).map((s) {
        return Map<String, dynamic>.from(s as Map);
      }).toList();

      // Garantir estado
      orc["estado"] = (orc["estado"] ?? "pendente").toString();

      return orc;
    }).toList();
  }

  // Atualizar estado do orçamento
  static Future<void> atualizarEstado(Map<String, dynamic> orc, String novoEstado) async {
    final box = await getBox();

    final values = box.values.toList();
    final keys = box.keys.toList();

    final numero = orc["numero"];
    final indexReal = values.indexWhere((o) => o["numero"] == numero);

    if (indexReal != -1) {
      final key = keys[indexReal];
      orc["estado"] = novoEstado;
      await box.put(key, orc);
    }
  }

  // Apagar orçamento
  static Future<void> apagarOrcamento(Map<String, dynamic> orc) async {
    final box = await getBox();

    final values = box.values.toList();
    final keys = box.keys.toList();

    final numero = orc["numero"];
    final indexReal = values.indexWhere((o) => o["numero"] == numero);

    if (indexReal != -1) {
      final key = keys[indexReal];
      await box.delete(key);
    }
  }

  // Atualizar orçamento completo
  static Future<void> atualizarOrcamento(int index, Map<String, dynamic> novo) async {
    final box = await getBox();

    // Garantir estado
    novo["estado"] = (novo["estado"] ?? "pendente").toString();

    await box.putAt(index, novo);
  }

  // Contar orçamentos do dia
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
