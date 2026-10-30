import 'package:flutter/material.dart';
import 'database.dart';
import 'orcamento_detalhes_page.dart';
import 'pdf_preview_page.dart';
import 'regenerar_pdfs.dart';

class OrcamentosGuardadosPage extends StatefulWidget {
  const OrcamentosGuardadosPage({super.key});

  @override
  State<OrcamentosGuardadosPage> createState() => _OrcamentosGuardadosPageState();
}

class _OrcamentosGuardadosPageState extends State<OrcamentosGuardadosPage> {

  String tempoDecorrido(DateTime data) {
    final agora = DateTime.now();
    final diff = agora.difference(data);

    if (diff.inSeconds < 60) return "há ${diff.inSeconds} segundos";
    if (diff.inMinutes < 60) return "há ${diff.inMinutes} minutos";
    if (diff.inHours < 24) return "há ${diff.inHours} horas";
    return "há ${diff.inDays} dias";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orçamentos Guardados"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              final count = await RegenerarPDFService.regenerarPDFsAntigos();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$count PDFs regenerados com sucesso!")),
              );

              setState(() {});
            },
          ),
        ],
      ),

      body: FutureBuilder(
        future: OrcamentoDB.listarOrcamentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum orçamento guardado.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final lista = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final orc = lista[index];
              final data = DateTime.parse(orc["data"]);

              final hora = "${data.hour.toString().padLeft(2, '0')}:"
                           "${data.minute.toString().padLeft(2, '0')}:"
                           "${data.second.toString().padLeft(2, '0')}";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    title: Text(
                      orc["cliente"]["nome"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    subtitle: Text(
                      "Total: ${orc["total"].toStringAsFixed(2)} €\n"
                      "Criado em: ${data.day}/${data.month}/${data.year} às $hora\n"
                      "${tempoDecorrido(data)}",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 👁️ OLHO VERMELHO PREMIUM
                        IconButton(
                          icon: const Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFFE50914),
                          ),
                          onPressed: () async {
                            if (orc["pdfBytes"] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Este orçamento não tem PDF guardado."),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PdfPreviewPage(pdfBytes: orc["pdfBytes"]),
                              ),
                            );
                          },
                        ),

                        // 🗑️ CAIXOTE VERMELHO PREMIUM + CONFIRMAÇÃO
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color(0xFFE50914),
                          ),
                          onPressed: () async {
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Eliminar Orçamento"),
                                  content: const Text(
                                    "Tem a certeza que deseja eliminar este orçamento?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Não"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Sim"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmar == true) {
                              await OrcamentoDB.apagarOrcamento(index);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrcamentoDetalhesPage(orcamento: orc),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
