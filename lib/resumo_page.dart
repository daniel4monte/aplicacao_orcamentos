import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'pdf_generator.dart';
import 'pdf_preview_page.dart';
import 'database.dart';
import 'empresa_db.dart';

class ResumoPage extends StatelessWidget {
  final Map<String, dynamic> cliente;
  final List<Map<String, dynamic>> servicos;

  const ResumoPage({
    super.key,
    required this.cliente,
    required this.servicos,
  });

  double get subtotal {
    double total = 0;
    for (var s in servicos) {
      total += s["subtotal"];
    }
    return total;
  }

  double get iva => subtotal * EmpresaDB.getIva();
  double get total => subtotal + iva;

  Future<String> gerarNumeroOrcamento() async {
    final agora = DateTime.now();
    final dia = agora.day.toString().padLeft(2, '0');
    final mes = agora.month.toString().padLeft(2, '0');
    final ano = agora.year.toString();

    final count = await OrcamentoDB.contarOrcamentosDoDia(dia, mes, ano);
    final numero = (count + 1).toString().padLeft(3, '0');

    return "ORC-$dia-$mes-$ano-$numero";
  }

  Future<void> guardarOrcamentoComPdf() async {
    final agora = DateTime.now();
    final numero = await gerarNumeroOrcamento();

    final Uint8List pdfBytes = await gerarPdf(
      cliente,
      servicos,
      qrLink: "https://www.google.com",
    );

    await OrcamentoDB.guardarOrcamento({
      "numero": numero,
      "cliente": cliente,
      "servicos": servicos,
      "subtotal": subtotal,
      "iva": iva,
      "total": total,
      "data": agora.toIso8601String(),
      "pdfBytes": pdfBytes,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumo do Orçamento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Dados do Cliente",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("Nome: ${cliente['nome']}"),
            Text("Morada: ${cliente['morada']}"),
            Text("Email: ${cliente['email']}"),
            Text("Telefone: ${cliente['telefone']}"),
            Text("NIF: ${cliente['nif']}"),
            const SizedBox(height: 20),
            const Text(
              "Serviços",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ...servicos.map((s) {
              return Card(
                color: const Color(0xFF1A1A1A),
                child: ListTile(
                  title: Text(
                    "${s['categoria']} - ${s['descricao']}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Qtd: ${s['quantidade']} | Preço: ${s['preco']}€ | Subtotal: ${s['subtotal']}€",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              "Totais",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("Subtotal: ${subtotal.toStringAsFixed(2)} €"),
            Text(
                "IVA (${(EmpresaDB.getIva() * 100).toStringAsFixed(0)}%): ${iva.toStringAsFixed(2)} €"),
            Text(
              "Total: ${total.toStringAsFixed(2)} €",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await guardarOrcamentoComPdf();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Orçamento guardado com sucesso!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child:
                    Text("Guardar Orçamento", style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("Voltar", style: TextStyle(fontSize: 20)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await guardarOrcamentoComPdf();

                    final Uint8List pdfBytes = await gerarPdf(
                      cliente,
                      servicos,
                      qrLink: "https://www.google.com",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfPreviewPage(pdfBytes: pdfBytes),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child:
                        Text("Imprimir / PDF", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
