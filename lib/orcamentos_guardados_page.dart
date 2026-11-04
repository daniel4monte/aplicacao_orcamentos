import 'package:flutter/material.dart';
import 'database.dart';
import 'pdf_preview_page.dart';

class OrcamentosGuardadosPage extends StatefulWidget {
  const OrcamentosGuardadosPage({super.key});

  @override
  State<OrcamentosGuardadosPage> createState() =>
      _OrcamentosGuardadosPageState();
}

class _OrcamentosGuardadosPageState extends State<OrcamentosGuardadosPage> {
  List<Map<String, dynamic>> lista = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    lista = await OrcamentoDB.listarOrcamentos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orçamentos Guardados")),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final orc = lista[index];

          return Card(
            color: const Color(0xFF1A1A1A),
            child: ListTile(
              title: Text(
                orc["numero"] ?? "Sem número",
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Total: ${orc['total']} €",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                onPressed: () {
                  final bytes = orc["pdfBytes"];
                  if (bytes != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfPreviewPage(pdfBytes: bytes),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
