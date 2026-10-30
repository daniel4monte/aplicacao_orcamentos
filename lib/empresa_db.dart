import 'dart:typed_data';
import 'package:hive/hive.dart';

class EmpresaDB {
  // Inicializar a box da empresa
  static Future<void> init() async {
    if (!Hive.isBoxOpen('empresa')) {
      await Hive.openBox('empresa');
    }
  }

  static Box get box => Hive.box('empresa');

  static void setNome(String nome) => box.put('nome', nome);
  static String getNome() => box.get('nome', defaultValue: 'A TUA EMPRESA');

  static void setMorada(String morada) => box.put('morada', morada);
  static String getMorada() => box.get('morada', defaultValue: '');

  static void setTelefone(String tel) => box.put('telefone', tel);
  static String getTelefone() => box.get('telefone', defaultValue: '');

  static void setEmail(String email) => box.put('email', email);
  static String getEmail() => box.get('email', defaultValue: '');

  static void setNif(String nif) => box.put('nif', nif);
  static String getNif() => box.get('nif', defaultValue: '');

  static void setIva(double iva) => box.put('iva', iva);
  static double getIva() => box.get('iva', defaultValue: 0.23);

  static void setLogo(Uint8List? bytes) => box.put('logo', bytes);
  static Uint8List? getLogo() => box.get('logo');

  static void setAssinatura(Uint8List? bytes) => box.put('assinatura', bytes);
  static Uint8List? getAssinatura() => box.get('assinatura');
}
