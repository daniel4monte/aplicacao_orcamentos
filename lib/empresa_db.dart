import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_service.dart';

class EmpresaDB {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final Box _box = Hive.box('empresa');

  static Future<void> guardarEmpresa({
    required String nome,
    required String morada,
    required String telefone,
    required String email,
    required String nif,
    required double iva,
  }) async {
    final user = AuthService.utilizadorAtual;
    if (user == null) return; // segurança extra

    final uid = user.uid;

    await _db.collection('empresas').doc(uid).set({
      "nome": nome,
      "morada": morada,
      "telefone": telefone,
      "email": email,
      "nif": nif,
      "iva": iva,
    });

    await sincronizarLocal({
      "nome": nome,
      "morada": morada,
      "telefone": telefone,
      "email": email,
      "nif": nif,
      "iva": iva,
    });
  }

  static Future<Map<String, dynamic>?> carregarEmpresa() async {
    final user = AuthService.utilizadorAtual;

    // 🔥 CORREÇÃO CRÍTICA: evitar crash se o login ainda não terminou
    if (user == null) return null;

    final uid = user.uid;
    final doc = await _db.collection('empresas').doc(uid).get();

    // Se não existir empresa no Firebase, devolve null
    return doc.data();
  }

  static Future<void> sincronizarLocal(Map<String, dynamic> dados) async {
    _box.put('nome', dados['nome']);
    _box.put('morada', dados['morada']);
    _box.put('telefone', dados['telefone']);
    _box.put('email', dados['email']);
    _box.put('nif', dados['nif']);
    _box.put('iva', dados['iva']);
  }

  static void guardarLogo(Uint8List bytes) => _box.put('logo', bytes);
  static Uint8List? getLogo() => _box.get('logo');

  static void guardarAssinatura(Uint8List bytes) =>
      _box.put('assinatura', bytes);
  static Uint8List? getAssinatura() => _box.get('assinatura');

  static String getNome() => _box.get('nome', defaultValue: '');
  static String getMorada() => _box.get('morada', defaultValue: '');
  static String getTelefone() => _box.get('telefone', defaultValue: '');
  static String getEmail() => _box.get('email', defaultValue: '');
  static String getNif() => _box.get('nif', defaultValue: '');
  static double getIva() => _box.get('iva', defaultValue: 0.23);
}
