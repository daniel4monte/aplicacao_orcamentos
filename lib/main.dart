import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'theme.dart';
import 'auth_service.dart';
import 'home_tabs.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'reset_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar Hive
  await Hive.initFlutter();
  await Hive.openBox('empresa');

  // 🔥 FORÇAR LOGOUT SEMPRE QUE A APP INICIA (inclui Hot Restart)
  await AuthService.logout();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Venda Orçamentos',
      theme: AppTheme.dark(),
      debugShowCheckedModeBanner: false,

      // ROTAS
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/reset': (context) => const ResetPasswordPage(),
        '/home': (context) => const HomeTabs(),
      },

      // PRIMEIRA PÁGINA
      home: const LoginPage(),
    );
  }
}
