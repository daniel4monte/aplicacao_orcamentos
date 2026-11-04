import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'empresa_db.dart';
import 'package:image_picker/image_picker.dart';

class ConfigEmpresaPage extends StatefulWidget {
  const ConfigEmpresaPage({super.key});

  @override
  State<ConfigEmpresaPage> createState() => _ConfigEmpresaPageState();
}

class _ConfigEmpresaPageState extends State<ConfigEmpresaPage> {
  final nome = TextEditingController();
  final morada = TextEditingController();
  final telefone = TextEditingController();
  final email = TextEditingController();
  final nif = TextEditingController();
  final iva = TextEditingController();

  Uint8List? logo;
  Uint8List? assinatura;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await EmpresaDB.carregarEmpresa();
    if (dados != null) {
      nome.text = dados["nome"];
      morada.text = dados["morada"];
      telefone.text = dados["telefone"];
      email.text = dados["email"];
      nif.text = dados["nif"];
      iva.text = dados["iva"].toString();
    }

    logo = EmpresaDB.getLogo();
    assinatura = EmpresaDB.getAssinatura();

    setState(() {});
  }

  Future<void> escolherImagem(bool isLogo) async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;

    final bytes = await img.readAsBytes();

    if (isLogo) {
      EmpresaDB.guardarLogo(bytes);
      logo = bytes;
    } else {
      EmpresaDB.guardarAssinatura(bytes);
      assinatura = bytes;
    }

    setState(() {});
  }

  Future<void> guardar() async {
    await EmpresaDB.guardarEmpresa(
      nome: nome.text,
      morada: morada.text,
      telefone: telefone.text,
      email: email.text,
      nif: nif.text,
      iva: double.tryParse(iva.text) ?? 0.23,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Empresa guardada!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuração da Empresa")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: nome, decoration: const InputDecoration(labelText: "Nome")),
          TextField(controller: morada, decoration: const InputDecoration(labelText: "Morada")),
          TextField(controller: telefone, decoration: const InputDecoration(labelText: "Telefone")),
          TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
          TextField(controller: nif, decoration: const InputDecoration(labelText: "NIF")),
          TextField(controller: iva, decoration: const InputDecoration(labelText: "IVA (%)")),
          const SizedBox(height: 20),
          const Text("Logo"),
          const SizedBox(height: 10),
          logo == null
              ? const Text("Nenhum logo selecionado")
              : Image.memory(logo!, height: 120),
          ElevatedButton(
            onPressed: () => escolherImagem(true),
            child: const Text("Escolher Logo"),
          ),
          const SizedBox(height: 20),
          const Text("Assinatura"),
          const SizedBox(height: 10),
          assinatura == null
              ? const Text("Nenhuma assinatura selecionada")
              : Image.memory(assinatura!, height: 120),
          ElevatedButton(
            onPressed: () => escolherImagem(false),
            child: const Text("Escolher Assinatura"),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: guardar,
            child: const Text("Guardar Empresa"),
          ),
        ],
      ),
    );
  }
}
