import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'cliente_page.dart';
import 'servicos_page.dart';
import 'resumo_page.dart';
import 'orcamentos_guardados_page.dart';
import 'config_empresa_page.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  int index = 0;

  final List<Widget> pages = [
    const HomeDashboardPage(),
    OrcamentosGuardadosPage(),
    const ConfigEmpresaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // Ir para Início
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Início', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => index = 0);
              },
            ),

            // Ir para Guardados
            ListTile(
              leading: const Icon(Icons.folder_open, color: Colors.white),
              title: const Text('Orçamentos Guardados',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => index = 1);
              },
            ),

            // Ir para Configurações
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Configurações',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => index = 2);
              },
            ),

            const Divider(color: Colors.white24),

            // 🔥 BOTÃO DE LOGOUT
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                await AuthService.logout();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: "Guardados",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configurações",
          ),
        ],
      ),
    );
  }
}

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Bem-vindo 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "O que deseja fazer hoje?",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),

            GestureDetector(
              onTap: () async {
                final cliente = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClientePage()),
                );
                if (cliente == null) return;

                final servicos = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServicosPage()),
                );
                if (servicos == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResumoPage(
                      cliente: cliente,
                      servicos: servicos,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add_circle_outline,
                        size: 32, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      "Criar Orçamento",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrcamentosGuardadosPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.folder_open,
                        size: 32, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      "Orçamentos Guardados",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConfigEmpresaPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.settings,
                        size: 32, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      "Configurações",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
