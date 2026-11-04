import 'package:flutter/material.dart';
import 'orcamento_db.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalFaturado = 0;

  int totalOrcamentos = 0;
  int totalClientes = 0;

  int pendentes = 0;
  int aceites = 0;
  int rejeitados = 0;

  Map<String, double> faturacaoMensal = {};

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final lista = await OrcamentoDB.listarOrcamentos();

    final Set<String> clientesUnicos = {};

    double faturado = 0;
    int pend = 0;
    int ace = 0;
    int rej = 0;

    final Map<String, double> mensal = {};

    for (var orc in lista) {
      final nomeOriginal =
          (orc['cliente']?['nome'] ?? '').toString().trim();
      final nomeNormalizado = nomeOriginal.toLowerCase().trim();

      if (nomeNormalizado.isNotEmpty) {
        clientesUnicos.add(nomeNormalizado);
      }

      final estado = (orc['estado'] ?? 'pendente').toString();

      if (estado == 'pendente') pend++;
      if (estado == 'aceite') {
        ace++;
        faturado += (orc['total'] ?? 0);
      }
      if (estado == 'rejeitado') rej++;

      final dataStr = (orc['data'] ?? '').toString();
      if (dataStr.isNotEmpty) {
        final chave = _mesAno(dataStr);
        mensal[chave] = (mensal[chave] ?? 0) + (orc['total'] ?? 0);
      }
    }

    setState(() {
      totalClientes = clientesUnicos.length;
      totalOrcamentos = lista.length;

      pendentes = pend;
      aceites = ace;
      rejeitados = rej;

      totalFaturado = faturado;
      faturacaoMensal = mensal;
    });
  }

  String _mesAno(String isoDate) {
    final d = DateTime.parse(isoDate);
    return '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Resumo Geral',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _cardResumo(
              titulo: 'Total Faturado (aceites)',
              valor: '${totalFaturado.toStringAsFixed(2)} €',
              icone: Icons.euro,
            ),
            _cardResumo(
              titulo: 'Total de Orçamentos Guardados',
              valor: '$totalOrcamentos',
              icone: Icons.description,
            ),
            _cardResumo(
              titulo: 'Total de Clientes',
              valor: '$totalClientes',
              icone: Icons.people,
            ),
            const SizedBox(height: 30),
            const Text(
              'Estados dos Orçamentos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _cardResumo(
              titulo: 'Pendentes',
              valor: '$pendentes',
              icone: Icons.hourglass_empty,
              corIcone: Colors.amber,
            ),
            _cardResumo(
              titulo: 'Aceites',
              valor: '$aceites',
              icone: Icons.check_circle,
              corIcone: Colors.green,
            ),
            _cardResumo(
              titulo: 'Rejeitados',
              valor: '$rejeitados',
              icone: Icons.cancel,
              corIcone: Colors.red,
            ),
            const SizedBox(height: 30),
            const Text(
              'Faturação Mensal',
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${e.value.toStringAsFixed(2)} €',
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
    Color corIcone = const Color(0xFFE50914),
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
          Icon(icone, color: corIcone, size: 32),
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
