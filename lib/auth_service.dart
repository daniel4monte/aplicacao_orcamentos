import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get utilizadorAtual => _auth.currentUser;

  // Login com email e password
  static Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Registar novo utilizador
  static Future<User?> registar(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Recuperar password
  static Future<void> recuperarPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
