import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarController = TextEditingController();

  bool mostrarPassword = false;
  bool loading = false;
  String erro = '';

  Future<void> registar() async {
    setState(() {
      loading = true;
      erro = '';
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmar = confirmarController.text.trim();

      if (email.isEmpty || password.isEmpty || confirmar.isEmpty) {
        setState(() {
          erro = 'Preencha todos os campos.';
          loading = false;
        });
        return;
      }

      if (password.length < 6) {
        setState(() {
          erro = 'A password deve ter pelo menos 6 caracteres.';
          loading = false;
        });
        return;
      }

      if (password != confirmar) {
        setState(() {
          erro = 'As passwords não coincidem.';
          loading = false;
        });
        return;
      }

      await AuthService.registar(email, password);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        erro = traduzErro(e.toString());
        loading = false;
      });
    }
  }

  String traduzErro(String erro) {
    if (erro.contains('invalid-email')) return 'Email inválido.';
    if (erro.contains('email-already-in-use')) return 'Este email já está registado.';
    if (erro.contains('weak-password')) return 'Password demasiado fraca.';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.white),
              const SizedBox(height: 20),

              const Text(
                'Criar Conta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // EMAIL
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

              // PASSWORD
              TextField(
                controller: passwordController,
                obscureText: !mostrarPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarPassword = !mostrarPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CONFIRMAR PASSWORD
              TextField(
                controller: confirmarController,
                obscureText: !mostrarPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirmar Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ERRO
              if (erro.isNotEmpty)
                Text(
                  erro,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 20),

              // BOTÃO REGISTAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : registar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Criar Conta',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // VOLTAR AO LOGIN
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Já tenho conta',
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
