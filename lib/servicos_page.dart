import 'package:flutter/material.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  final descricaoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final precoController = TextEditingController();

  String categoriaSelecionada = "Carpintaria";

  final List<Map<String, dynamic>> servicos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Serviços"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: categoriaSelecionada,
              items: const [
                DropdownMenuItem(
                    value: "Carpintaria", child: Text("Carpintaria")),
                DropdownMenuItem(
                    value: "Eletricidade", child: Text("Eletricidade")),
                DropdownMenuItem(
                    value: "Domótica", child: Text("Domótica")),
                DropdownMenuItem(
                    value: "Construção Civil",
                    child: Text("Construção Civil")), // ← ALTERADO
                DropdownMenuItem(
                    value: "Caixilharis", child: Text("Caixilharias")),
              ],
              onChanged: (value) {
                setState(() {
                  categoriaSelecionada = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Categoria"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descricaoController,
              decoration:
                  const InputDecoration(labelText: "Descrição do serviço"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantidade"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: precoController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Preço unitário (€)"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final descricao = descricaoController.text;
                final quantidade =
                    int.tryParse(quantidadeController.text) ?? 0;
                final preco = double.tryParse(precoController.text) ?? 0.0;

                if (descricao.isNotEmpty && quantidade > 0 && preco > 0) {
                  setState(() {
                    servicos.add({
                      "categoria": categoriaSelecionada,
                      "descricao": descricao,
                      "quantidade": quantidade,
                      "preco": preco,
                      "subtotal": quantidade * preco,
                    });
                  });

                  descricaoController.clear();
                  quantidadeController.clear();
                  precoController.clear();
                }
              },
              child: const Text("Adicionar Serviço"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: servicos.length,
                itemBuilder: (context, index) {
                  final s = servicos[index];
                  return Card(
                    child: ListTile(
                      title:
                          Text("${s['categoria']} - ${s['descricao']}"),
                      subtitle: Text(
                        "Qtd: ${s['quantidade']}  |  Preço: ${s['preco']}€  |  Subtotal: ${s['subtotal']}€",
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, servicos);
              },
              child: const Text("Guardar e Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
