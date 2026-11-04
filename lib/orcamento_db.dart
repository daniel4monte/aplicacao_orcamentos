import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class OrcamentoDB {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _colecao() {
    return _db.collection('budgets');
  }

  static Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final uid = AuthService.utilizadorAtual!.uid;

    final snap = await _colecao()
        .where('userId', isEqualTo: uid)
        .orderBy('data', descending: true)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<void> guardarOrcamento(Map<String, dynamic> dados) async {
    final uid = AuthService.utilizadorAtual!.uid;
    dados['userId'] = uid;
    await _colecao().add(dados);
  }

  static Future<void> atualizarEstado(
      Map<String, dynamic> orc, String estado) async {
    final String id = orc['id'];
    await _colecao().doc(id).update({'estado': estado});
  }

  static Future<void> apagarOrcamento(Map<String, dynamic> orc) async {
    final String id = orc['id'];
    await _colecao().doc(id).delete();
  }

  static Future<void> atualizarOrcamento(
      int index, Map<String, dynamic> novo) async {
    final uid = AuthService.utilizadorAtual!.uid;

    final snap = await _colecao()
        .where('userId', isEqualTo: uid)
        .orderBy('data', descending: true)
        .get();

    if (index < 0 || index >= snap.docs.length) return;

    final id = snap.docs[index].id;
    await _colecao().doc(id).update(novo);
  }

  static Future<int> contarOrcamentosDoDia(
      String dia, String mes, String ano) async {
    final uid = AuthService.utilizadorAtual!.uid;

    final inicio =
        DateTime(int.parse(ano), int.parse(mes), int.parse(dia), 0, 0, 0);
    final fim =
        DateTime(int.parse(ano), int.parse(mes), int.parse(dia), 23, 59, 59);

    final snap = await _colecao()
        .where('userId', isEqualTo: uid)
        .where('data', isGreaterThanOrEqualTo: inicio.toIso8601String())
        .where('data', isLessThanOrEqualTo: fim.toIso8601String())
        .get();

    return snap.docs.length;
  }
}
