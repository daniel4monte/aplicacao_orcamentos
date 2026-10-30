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
  late TextEditingController nomeCtrl;
  late TextEditingController moradaCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController telefoneCtrl;
  late TextEditingController nifCtrl;

  @override
  void initState() {
    super.initState();

    final cliente = widget.orcamento["cliente"];

    nomeCtrl = TextEditingController(text: cliente["nome"]);
    moradaCtrl = TextEditingController(text: cliente["morada"]);
    emailCtrl = TextEditingController(text: cliente["email"]);
    telefoneCtrl = TextEditingController(text: cliente["telefone"]);
    nifCtrl = TextEditingController(text: cliente["nif"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Orçamento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: moradaCtrl,
              decoration: const InputDecoration(labelText: "Morada"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: telefoneCtrl,
              decoration: const InputDecoration(labelText: "Telefone"),
            ),
            TextField(
              controller: nifCtrl,
              decoration: const InputDecoration(labelText: "NIF"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                final novoCliente = {
                  "nome": nomeCtrl.text,
                  "morada": moradaCtrl.text,
                  "email": emailCtrl.text,
                  "telefone": telefoneCtrl.text,
                  "nif": nifCtrl.text,
                };

                final novoOrcamento = {
                  ...widget.orcamento,
                  "cliente": novoCliente,
                };

                OrcamentoDB.atualizarOrcamento(widget.index, novoOrcamento);

                Navigator.pop(context, true);
              },
              child: const Text("Guardar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}
