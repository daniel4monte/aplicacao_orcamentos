import 'package:flutter/material.dart';

class OrcamentoDetalhesPage extends StatelessWidget {
  final Map<String, dynamic> orcamento;

  const OrcamentoDetalhesPage({super.key, required this.orcamento});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> cliente =
        orcamento["cliente"] as Map<String, dynamic>;

    final List<Map<String, dynamic>> servicos =
        List<Map<String, dynamic>>.from(
      orcamento["servicos"] as List,
    );

    final double subtotal =
        (orcamento["subtotal"] as num).toDouble();
    final double iva =
        (orcamento["iva"] as num).toDouble();
    final double total =
        (orcamento["total"] as num).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Orçamento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cliente: ${cliente['nome']}"),
            Text("Morada: ${cliente['morada']}"),
            Text("Email: ${cliente['email']}"),
            Text("Telefone: ${cliente['telefone']}"),
            Text("NIF: ${cliente['nif']}"),

            const SizedBox(height: 20),

            const Text(
              "Serviços",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: servicos.length,
                itemBuilder: (context, index) {
                  final s = servicos[index];
                  return ListTile(
                    title: Text("${s['categoria']} - ${s['descricao']}"),
                    subtitle: Text(
                      "Qtd: ${s['quantidade']} | Preço: ${s['preco']}€ | Subtotal: ${s['subtotal']}€",
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text("Subtotal: ${subtotal.toStringAsFixed(2)} €"),
            Text("IVA: ${iva.toStringAsFixed(2)} €"),
            Text(
              "Total: ${total.toStringAsFixed(2)} €",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
