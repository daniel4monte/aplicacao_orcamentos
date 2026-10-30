import 'package:hive/hive.dart';

class OrcamentoDB {
  static Future<Box> _openBox() async {
    return await Hive.openBox('orcamentos');
  }

  static Future<void> guardarOrcamento(Map<String, dynamic> orcamento) async {
    final box = await _openBox();
    await box.add(orcamento);
  }

  static Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final box = await _openBox();

    return box.values.map((e) {
      // Converter o orçamento principal
      final Map<String, dynamic> orc =
          Map<String, dynamic>.from(e as Map);

      // Converter cliente
      if (orc["cliente"] is Map) {
        orc["cliente"] =
            Map<String, dynamic>.from(orc["cliente"] as Map);
      }

      // Converter lista de serviços
      if (orc["servicos"] is List) {
        orc["servicos"] = (orc["servicos"] as List).map((s) {
          return Map<String, dynamic>.from(s as Map);
        }).toList();
      }

      return orc;
    }).toList();
  }

  static Future<void> apagarOrcamento(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }

  static Future<void> atualizarOrcamento(int index, Map<String, dynamic> novoOrcamento) async {
    final box = await _openBox();
    await box.putAt(index, novoOrcamento);
  }
}
