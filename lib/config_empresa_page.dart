import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'empresa_db.dart';

class ConfigEmpresaPage extends StatefulWidget {
  const ConfigEmpresaPage({super.key});

  @override
  State<ConfigEmpresaPage> createState() => _ConfigEmpresaPageState();
}

class _ConfigEmpresaPageState extends State<ConfigEmpresaPage> {
  final picker = ImagePicker();

  late final TextEditingController _nomeController;
  late final TextEditingController _moradaController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _nifController;
  late final TextEditingController _ivaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: EmpresaDB.getNome());
    _moradaController = TextEditingController(text: EmpresaDB.getMorada());
    _telefoneController = TextEditingController(text: EmpresaDB.getTelefone());
    _emailController = TextEditingController(text: EmpresaDB.getEmail());
    _nifController = TextEditingController(text: EmpresaDB.getNif());
    _ivaController =
        TextEditingController(text: (EmpresaDB.getIva() * 100).toString());
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _moradaController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _nifController.dispose();
    _ivaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações da Empresa")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Nome da empresa"),
            controller: _nomeController,
            onChanged: EmpresaDB.setNome,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Morada"),
            controller: _moradaController,
            onChanged: EmpresaDB.setMorada,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Telefone"),
            controller: _telefoneController,
            onChanged: EmpresaDB.setTelefone,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Email"),
            controller: _emailController,
            onChanged: EmpresaDB.setEmail,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "NIF"),
            controller: _nifController,
            onChanged: EmpresaDB.setNif,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "IVA (%)"),
            controller: _ivaController,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final iva = double.tryParse(v) ?? 23;
              EmpresaDB.setIva(iva / 100);
            },
          ),

          const SizedBox(height: 20),
          const Text("Logotipo", style: TextStyle(fontSize: 18)),

          ElevatedButton(
            onPressed: () async {
              final img = await picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                EmpresaDB.setLogo(await img.readAsBytes());
                setState(() {});
              }
            },
            child: const Text("Escolher Logotipo"),
          ),

          if (EmpresaDB.getLogo() != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.memory(
                EmpresaDB.getLogo()!,
                height: 120,
              ),
            ),

          const SizedBox(height: 20),
          const Text("Assinatura", style: TextStyle(fontSize: 18)),

          ElevatedButton(
            onPressed: () async {
              final img = await picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                EmpresaDB.setAssinatura(await img.readAsBytes());
                setState(() {});
              }
            },
            child: const Text("Escolher Assinatura"),
          ),

          if (EmpresaDB.getAssinatura() != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.memory(
                EmpresaDB.getAssinatura()!,
                height: 120,
              ),
            ),
        ],
      ),
    );
  }
}
