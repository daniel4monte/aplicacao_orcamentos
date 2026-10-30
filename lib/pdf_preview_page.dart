import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PdfPreviewPage extends StatelessWidget {
  final Uint8List pdfBytes;

  const PdfPreviewPage({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pré‑visualização do PDF"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ← BOTÃO VOLTAR
        ),
      ),

      // MOSTRAR O PDF
      body: PdfPreview(
        build: (format) => pdfBytes,
        canChangePageFormat: false,
        canDebug: false,
        allowSharing: false,
        allowPrinting: false,
      ),

      // APENAS 3 BOTÕES
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // VOLTAR
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),

            // IMPRIMIR
            ElevatedButton(
              onPressed: () async {
                await Printing.layoutPdf(onLayout: (_) => pdfBytes);
              },
              child: const Text("Imprimir"),
            ),

            // PARTILHAR
            ElevatedButton(
              onPressed: () async {
                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: "orcamento.pdf",
                );
              },
              child: const Text("Partilhar"),
            ),
          ],
        ),
      ),
    );
  }
}
