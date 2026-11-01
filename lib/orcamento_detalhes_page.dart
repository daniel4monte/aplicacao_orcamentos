import 'package:flutter/material.dart';

class OrcamentoDetalhesPage extends StatelessWidget {
  final Map<String, dynamic> orcamento;

  const OrcamentoDetalhesPage({super.key, required this.orcamento});

  Color corEstado(String estado) {
    switch (estado) {
      case "aceite": return Colors.green;
      case "rejeitado": return Colors.red;
      default: return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> orc = Map<String, dynamic>.from(orcamento);
    final Map<String, dynamic> cliente = Map<String, dynamic>.from(orc["cliente"]);
    final List<Map<String, dynamic>> servicos =
        (orc["servicos"] as List).map((s) => Map<String, dynamic>.from(s)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: Text("Orçamento ${orc["numero"] ?? ""}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: corEstado(orc["estado"]),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Estado: ${orc["estado"]}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Dados do Cliente",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            _linha("Nome", cliente["nome"]),
            _linha("Morada", cliente["morada"]),
            _linha("Email", cliente["email"]),
            _linha("Telefone", cliente["telefone"]),
            _linha("NIF", cliente["nif"]),

            const SizedBox(height: 25),

            const Text(
              "Serviços",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            ...servicos.map((s) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${s["categoria"]} - ${s["descricao"]}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Qtd: ${s["quantidade"]} | Preço: ${s["preco"]}€",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "Subtotal: ${s["subtotal"]}€",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 25),

            const Text(
              "Totais",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            _linha("Subtotal", "${orc["subtotal"].toStringAsFixed(2)} €"),
            _linha("IVA", "${orc["iva"].toStringAsFixed(2)} €"),
            _linha("Total", "${orc["total"].toStringAsFixed(2)} €", bold: true),
          ],
        ),
      ),
    );
  }

  Widget _linha(String titulo, String valor, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            valor,
            style: TextStyle(
              color: Colors.white,
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
