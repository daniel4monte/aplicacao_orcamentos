import 'package:flutter/material.dart';
import 'database.dart';

class EditarOrcamentoPage extends StatefulWidget {
  final Map<String, dynamic> orcamento;
  final int index;

  const EditarOrcamentoPage({
    super.key,
    required this.orcamento,
    required this.index,
  });

  @override
  State<EditarOrcamentoPage> createState() => _EditarOrcamentoPageState();
}

class _EditarOrcamentoPageState extends State<EditarOrcamentoPage> {
  late TextEditingController estadoController;

  @override
  void initState() {
    super.initState();
    estadoController =
        TextEditingController(text: widget.orcamento["estado"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Orçamento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: estadoController,
              decoration: const InputDecoration(labelText: "Estado"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final novo = Map<String, dynamic>.from(widget.orcamento);
                novo["estado"] = estadoController.text;

                await OrcamentoDB.atualizarOrcamento(widget.index, novo);

                Navigator.pop(context);
              },
              child: const Text("Guardar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}
