import 'package:flutter/material.dart';
import 'database.dart';
import 'orcamento_detalhes_page.dart';
import 'pdf_preview_page.dart';
import 'regenerar_pdfs.dart';
import 'dashboard_page.dart';

class OrcamentosGuardadosPage extends StatefulWidget {
  const OrcamentosGuardadosPage({super.key});

  @override
  State<OrcamentosGuardadosPage> createState() => _OrcamentosGuardadosPageState();
}

class _OrcamentosGuardadosPageState extends State<OrcamentosGuardadosPage> {
  String pesquisa = "";

  String tempoDecorrido(DateTime data) {
    final agora = DateTime.now();
    final diff = agora.difference(data);

    if (diff.inSeconds < 60) return "há ${diff.inSeconds} segundos";
    if (diff.inMinutes < 60) return "há ${diff.inMinutes} minutos";
    if (diff.inHours < 24) return "há ${diff.inHours} horas";
    return "há ${diff.inDays} dias";
  }

  Color corEstado(String estado) {
    switch (estado) {
      case "aceite":
        return Colors.green;
      case "rejeitado":
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Orçamentos Guardados"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            },
          ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Pesquisar cliente...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (txt) {
                setState(() {
                  pesquisa = txt.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
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

                List<Map<String, dynamic>> lista = snapshot.data!;

                lista = lista.where((orc) {
                  final nome =
                      (orc["cliente"]?["nome"] ?? "").toString().toLowerCase();
                  return nome.contains(pesquisa);
                }).toList();

                if (lista.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum resultado encontrado.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final orc = lista[index];
                    final data = DateTime.parse(orc["data"]);

                    final hora =
                        "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}:${data.second.toString().padLeft(2, '0')}";

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
                      child: Column(
                        children: [
                          // -------------------------------
                          // TÍTULO INVERTIDO
                          // -------------------------------
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Row(
                              children: [
                                // ● Estado
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: corEstado(
                                      (orc["estado"] ?? "pendente").toString(),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // 🧑 Nome do cliente (ESQUERDA)
                                Expanded(
                                  child: Text(
                                    (orc["cliente"]?["nome"] ??
                                            "Cliente desconhecido")
                                        .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // 🔢 Número do orçamento (DIREITA)
                                Text(
                                  (orc["numero"] ?? "Sem número").toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "Total: ${orc["total"].toStringAsFixed(2)} €\n"
                              "Criado em: ${data.day}/${data.month}/${data.year} às $hora\n"
                              "${tempoDecorrido(data)}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OrcamentoDetalhesPage(orcamento: orc),
                                ),
                              );
                            },
                          ),

                          // -------------------------------
                          // BOTÕES DE ESTADO (SEM OVERFLOW)
                          // -------------------------------
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.hourglass_empty,
                                      color: Colors.amber),
                                  onPressed: () async {
                                    await OrcamentoDB.atualizarEstado(
                                        orc, "pendente");
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () async {
                                    await OrcamentoDB.atualizarEstado(
                                        orc, "aceite");
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red),
                                  onPressed: () async {
                                    await OrcamentoDB.atualizarEstado(
                                        orc, "rejeitado");
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye,
                                      color: Color(0xFFE50914)),
                                  onPressed: () async {
                                    if (orc["pdfBytes"] == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Este orçamento não tem PDF guardado.",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PdfPreviewPage(
                                          pdfBytes: orc["pdfBytes"],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Color(0xFFE50914)),
                                  onPressed: () async {
                                    final confirmar =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Eliminar Orçamento"),
                                          content: const Text(
                                            "Tem a certeza que deseja eliminar este orçamento?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, false),
                                              child: const Text("Não"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, true),
                                              child: const Text("Sim"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmar == true) {
                                      await OrcamentoDB.apagarOrcamento(orc);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
