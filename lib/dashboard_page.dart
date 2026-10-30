import 'package:flutter/material.dart';
import 'database.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalFaturado = 0;
  int totalOrcamentos = 0;
  int totalClientes = 0;

  Map<String, double> faturacaoMensal = {};

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final lista = await OrcamentoDB.listarOrcamentos();

    double faturado = 0;
    int clientes = 0;

    Map<String, double> mensal = {};

    for (var orc in lista) {
      faturado += orc["total"];

      final nomeCliente = orc["cliente"]["nome"];
      mensal[_mesAno(orc["data"])] =
          (mensal[_mesAno(orc["data"])] ?? 0) + orc["total"];

      clientes++;
    }

    setState(() {
      totalFaturado = faturado;
      totalOrcamentos = lista.length;
      totalClientes = clientes;
      faturacaoMensal = mensal;
    });
  }

  String _mesAno(String isoDate) {
    final d = DateTime.parse(isoDate);
    return "${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Resumo Geral",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            _cardResumo(
              titulo: "Total Faturado",
              valor: "${totalFaturado.toStringAsFixed(2)} €",
              icone: Icons.euro,
            ),

            _cardResumo(
              titulo: "Total de Orçamentos",
              valor: "$totalOrcamentos",
              icone: Icons.description,
            ),

            _cardResumo(
              titulo: "Total de Clientes",
              valor: "$totalClientes",
              icone: Icons.people,
            ),

            const SizedBox(height: 30),

            const Text(
              "Faturação Mensal",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            ...faturacaoMensal.entries.map((e) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "${e.value.toStringAsFixed(2)} €",
                      style: const TextStyle(
                        color: Color(0xFFE50914),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _cardResumo({
    required String titulo,
    required String valor,
    required IconData icone,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Icon(icone, color: Color(0xFFE50914), size: 32),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
