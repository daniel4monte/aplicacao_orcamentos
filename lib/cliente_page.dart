import 'package:flutter/material.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _nifController;

  // Campos da morada / local da obra
  late TextEditingController _obraRuaController;
  late TextEditingController _obraNumeroController;
  late TextEditingController _obraPostalController;
  late TextEditingController _obraLocalidadeController;
  late TextEditingController _obraDistritoController;
  late TextEditingController _obraObsController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
    _nifController = TextEditingController();

    _obraRuaController = TextEditingController();
    _obraNumeroController = TextEditingController();
    _obraPostalController = TextEditingController();
    _obraLocalidadeController = TextEditingController();
    _obraDistritoController = TextEditingController();
    _obraObsController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _nifController.dispose();

    _obraRuaController.dispose();
    _obraNumeroController.dispose();
    _obraPostalController.dispose();
    _obraLocalidadeController.dispose();
    _obraDistritoController.dispose();
    _obraObsController.dispose();

    super.dispose();
  }

  void guardarCliente() {
    // Construir a morada completa como STRING (compatível com ResumoPage)
    final morada = StringBuffer();

    if (_obraRuaController.text.isNotEmpty) {
      morada.write(_obraRuaController.text);
    }
    if (_obraNumeroController.text.isNotEmpty) {
      morada.write(", Nº ${_obraNumeroController.text}");
    }
    if (_obraPostalController.text.isNotEmpty ||
        _obraLocalidadeController.text.isNotEmpty) {
      morada.write(" | ");
      if (_obraPostalController.text.isNotEmpty) {
        morada.write(_obraPostalController.text);
      }
      if (_obraLocalidadeController.text.isNotEmpty) {
        morada.write(" ${_obraLocalidadeController.text}");
      }
    }
    if (_obraDistritoController.text.isNotEmpty) {
      morada.write(" | ${_obraDistritoController.text}");
    }
    if (_obraObsController.text.isNotEmpty) {
      morada.write("\nObs: ${_obraObsController.text}");
    }

    final cliente = {
      "nome": _nomeController.text,
      "email": _emailController.text,
      "telefone": _telefoneController.text,
      "nif": _nifController.text,
      "morada": morada.toString(),   // 🔥 STRING FINAL (obrigatório)
    };

    Navigator.pop(context, cliente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dados do Cliente")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Dados do Cliente",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          TextField(
            decoration: const InputDecoration(labelText: "Nome"),
            controller: _nomeController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Email"),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Telefone"),
            controller: _telefoneController,
            keyboardType: TextInputType.phone,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "NIF"),
            controller: _nifController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 30),

          // 🔥 Estes campos agora fazem parte de "Dados do Cliente"
          TextField(
            decoration: const InputDecoration(labelText: "Rua / Morada da Obra"),
            controller: _obraRuaController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Número da Porta"),
            controller: _obraNumeroController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Código Postal"),
            controller: _obraPostalController,
            keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Localidade"),
            controller: _obraLocalidadeController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Distrito"),
            controller: _obraDistritoController,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Observações da Obra (opcional)",
            ),
            controller: _obraObsController,
            maxLines: 3,
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: guardarCliente,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text("Guardar", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
