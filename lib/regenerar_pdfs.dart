import 'dart:typed_data';
import 'database.dart';
import 'pdf_generator.dart';

class RegenerarPDFService {
  static Future<int> regenerarPDFsAntigos() async {
    final lista = await OrcamentoDB.listarOrcamentos();
    int regenerados = 0;

    for (int i = 0; i < lista.length; i++) {
      final orc = lista[i];

      if (orc["pdfBytes"] == null) {
        final Uint8List pdfBytes = await gerarPdf(
          Map<String, dynamic>.from(orc["cliente"]),
          List<Map<String, dynamic>>.from(orc["servicos"]),
          qrLink: "https://www.google.com",
        );

        final novoOrcamento = Map<String, dynamic>.from(orc);
        novoOrcamento["pdfBytes"] = pdfBytes;

        await OrcamentoDB.atualizarOrcamento(i, novoOrcamento);

        regenerados++;
      }
    }

    return regenerados;
  }
}
