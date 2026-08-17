
import 'package:flutter/material.dart';
import 'package:sistema_login/pages/home_page.dart';
import 'package:sistema_login/services/api_service.dart';
import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // O _ é reservado e significa privado
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool esconderSenha = true;
  bool carregando = false;

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  Future<void> entrar() async {
    String email = emailController.text.trim();
    String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      mostrarMensagem(
        'Preencha o e-mail e a senha.',
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      final resultado = await ApiService.login(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      if (resultado['sucesso'] == true) {
        final dados = resultado['dados'];

        String nome = dados['nome'] ?? 'Usuário';
        String emailUsuario = dados['email'] ?? email;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              nomeUsuario: nome,
              emailUsuario: emailUsuario,
            ),
          ),
        );

        return;
      }

      if (resultado['sucesso'] == false) {
        mostrarMensagem(
          resultado['mensagem'] ?? 'E-mail ou senha incorretos.',
        );
        return;
      }
    } catch (e) {
      mostrarMensagem(
        'Não foi possível conectar ao servidor.',
      );
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            const Icon(
              Icons.account_circle,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              'Bem-vindo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Entre com a sua conta para acessar o sistema',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: senhaController,
              obscureText: esconderSenha,
              decoration: InputDecoration(
                labelText: 'Senha',
                hintText: 'Digite sua Senha',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      esconderSenha = !esconderSenha;
                    });
                  },
                  icon: Icon(
                    esconderSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: carregando ? null : entrar,
              icon: carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.login),
              label: Text(
                carregando ? 'Entrando...' : 'Entrar',
              ),
            ),

            const SizedBox(height: 25),

            OutlinedButton.icon(
              onPressed: carregando ? null : abrirCadastro,
              icon: const Icon(Icons.person_add),
              label: const Text('Criar usuário'),
            ),
          ],
        ),
      ),
    );
  }
}
