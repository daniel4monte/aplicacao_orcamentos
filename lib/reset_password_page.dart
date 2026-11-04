import 'package:flutter/material.dart';
import 'auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  bool loading = false;
  String mensagem = '';
  String erro = '';

  Future<void> resetPassword() async {
    setState(() {
      loading = true;
      mensagem = '';
      erro = '';
    });

    try {
      final email = emailController.text.trim();

      if (email.isEmpty) {
        setState(() {
          erro = 'Introduza o email.';
          loading = false;
        });
        return;
      }

      await AuthService.recuperarPassword(email);

      setState(() {
        mensagem = 'Email enviado! Verifique a sua caixa de entrada.';
        loading = false;
      });
    } catch (e) {
      setState(() {
        erro = traduzErro(e.toString());
        loading = false;
      });
    }
  }

  String traduzErro(String erro) {
    if (erro.contains('invalid-email')) return 'Email inválido.';
    if (erro.contains('user-not-found')) return 'Utilizador não encontrado.';
    return 'Ocorreu um erro. Tente novamente.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.white),
              const SizedBox(height: 20),

              const Text(
                'Recuperar Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (mensagem.isNotEmpty)
                Text(
                  mensagem,
                  style: const TextStyle(color: Colors.greenAccent),
                ),

              if (erro.isNotEmpty)
                Text(
                  erro,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enviar Email',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Voltar ao Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
