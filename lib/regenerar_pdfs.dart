import 'dart:typed_data';
import 'package:app_venda_or/database.dart';
import 'package:app_venda_or/pdf_generator.dart';

class RegenerarPDFService {
  static Future<int> regenerarPDFsAntigos() async {
    final lista = await OrcamentoDB.listarOrcamentos();
    int regenerados = 0;

    for (int i = 0; i < lista.length; i++) {
      final orc = lista[i];

      // Se não tiver PDF guardado → regenerar
      if (orc["pdfBytes"] == null) {
        final Uint8List pdfBytes = await gerarPdf(
          orc["cliente"],
          List<Map<String, dynamic>>.from(orc["servicos"]),
          qrLink: "https://www.google.com",
        );

        // Atualizar orçamento com PDF
        final novoOrcamento = Map<String, dynamic>.from(orc);
        novoOrcamento["pdfBytes"] = pdfBytes;

        await OrcamentoDB.atualizarOrcamento(i, novoOrcamento);

        regenerados++;
      }
    }

    return regenerados;
  }
}
