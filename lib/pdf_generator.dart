import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode/barcode.dart';
import 'empresa_db.dart';

Future<Uint8List> gerarPdf(
  Map<String, dynamic> cliente,
  List<Map<String, dynamic>> servicos, {
  String? qrLink,
}) async {
  final pdf = pw.Document();

  final nomeEmpresa = EmpresaDB.getNome();
  final moradaEmpresa = EmpresaDB.getMorada();
  final telefoneEmpresa = EmpresaDB.getTelefone();
  final emailEmpresa = EmpresaDB.getEmail();
  final nifEmpresa = EmpresaDB.getNif();
  final ivaPercent = EmpresaDB.getIva();
  final logoBytes = EmpresaDB.getLogo();
  final assinaturaBytes = EmpresaDB.getAssinatura();

  double subtotal = 0;
  for (var s in servicos) subtotal += s["subtotal"];
  double iva = subtotal * ivaPercent;
  double total = subtotal + iva;

  pw.Widget? qrWidget;
  if (qrLink != null && qrLink.isNotEmpty) {
    final qr = Barcode.qrCode();
    final svg = qr.toSvg(qrLink, width: 120, height: 120);
    qrWidget = pw.SvgImage(svg: svg);
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            pw.Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: pw.Container(
                width: 120,
                color: PdfColors.blue900,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(140, 40, 40, 40),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            nomeEmpresa,
                            style: pw.TextStyle(
                              fontSize: 26,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(moradaEmpresa),
                          pw.Text("Telefone: $telefoneEmpresa"),
                          pw.Text("Email: $emailEmpresa"),
                          pw.Text("NIF: $nifEmpresa"),
                        ],
                      ),
                      if (logoBytes != null)
                        pw.Container(
                          width: 100,
                          height: 100,
                          child: pw.Image(
                            pw.MemoryImage(logoBytes),
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    "Orçamento",
                    style: pw.TextStyle(
                      fontSize: 30,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Dados do Cliente",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text("Nome: ${cliente['nome']}"),
                  pw.Text("Morada: ${cliente['morada']}"),
                  pw.Text("Email: ${cliente['email']}"),
                  pw.Text("Telefone: ${cliente['telefone']}"),
                  pw.Text("NIF: ${cliente['nif']}"),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    "Serviços",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey600),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey300,
                        ),
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Categoria")),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Descrição")),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Qtd")),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Preço")),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text("Subtotal")),
                        ],
                      ),
                      ...servicos.map((s) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text("${s['categoria']}")),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text("${s['descricao']}")),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text("${s['quantidade']}")),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text("${s['preco']} €")),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text("${s['subtotal']} €")),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("Subtotal: ${subtotal.toStringAsFixed(2)} €"),
                          pw.Text(
                              "IVA (${(ivaPercent * 100).toStringAsFixed(0)}%): ${iva.toStringAsFixed(2)} €"),
                          pw.Text(
                            "Total: ${total.toStringAsFixed(2)} €",
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      if (qrWidget != null)
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.blue900),
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: qrWidget,
                        ),
                      if (assinaturaBytes != null)
                        pw.Column(
                          children: [
                            pw.Container(
                              width: 150,
                              height: 80,
                              child: pw.Image(
                                pw.MemoryImage(assinaturaBytes),
                                fit: pw.BoxFit.contain,
                              ),
                            ),
                            pw.Text("Assinatura"),
                          ],
                        ),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Divider(),
                  pw.Center(
                    child: pw.Text(
                      "Obrigado pela preferência!",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Condições Gerais",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text(
              "• Este orçamento é válido por 30 dias.\n"
              "• Os valores apresentados incluem IVA à taxa legal.\n"
              "• A execução dos serviços depende de disponibilidade.\n"
              "• O pagamento deve ser efetuado conforme acordado.\n"
              "• Materiais adicionais serão cobrados à parte.\n"
              "• A empresa não se responsabiliza por danos pré-existentes.\n"
              "• O cliente confirma que os dados fornecidos estão corretos.\n",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.Spacer(),
            pw.Center(
              child: pw.Text(
                "Fim do documento",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
