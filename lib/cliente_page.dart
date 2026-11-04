import 'package:flutter/material.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final nome = TextEditingController();
  final morada = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final nif = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dados do Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: nome, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: morada, decoration: const InputDecoration(labelText: "Morada")),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: telefone, decoration: const InputDecoration(labelText: "Telefone")),
            TextField(controller: nif, decoration: const InputDecoration(labelText: "NIF")),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "nome": nome.text,
                  "morada": morada.text,
                  "email": email.text,
                  "telefone": telefone.text,
                  "nif": nif.text,
                });
              },
              child: const Text("Guardar e Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
