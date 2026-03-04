import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:condexpress/themes/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty || _senhaController.text.isEmpty) {
      _showSnackBar("Por favor, preencha todos os campos");
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      _showSnackBar("As senhas não coincidem");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Criar usuário no Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // 2. Salvar dados adicionais no Realtime Database
      if (userCredential.user != null) {
        await FirebaseDatabase.instance.ref('users/${userCredential.user!.uid}').set({
          'uid': userCredential.user!.uid,
          'nome': _nomeController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': ServerValue.timestamp,
        });

        await userCredential.user!.updateDisplayName(_nomeController.text.trim());

        // --- NOVIDADE AQUI ---
        // Deslogamos o usuário imediatamente após criar a conta
        await FirebaseAuth.instance.signOut();
      }

      _showSnackBar("Conta criada com sucesso! Faça login para continuar.");

      // MUDADO: Agora volta para o login em vez de ir para a Home
      if (mounted) context.go('/login');

    } on FirebaseAuthException catch (e) {
      String message = "Erro ao cadastrar";
      if (e.code == 'weak-password') message = "A senha é muito fraca";
      else if (e.code == 'email-already-in-use') message = "Este e-mail já está em uso";
      _showSnackBar(message);
    } catch (e) {
      _showSnackBar("Erro técnico: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 4)));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    const hintStyle = TextStyle(fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/login'),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text('Criar Conta', style: TextStyle(fontSize: size.width * 0.08, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Preencha os campos para criar seu acesso',
                  style: TextStyle(fontSize: size.width * 0.04, color: themeProvider.themeMode == ThemeMode.light ? Colors.black87 : Colors.grey)),

                const SizedBox(height: 40),
                _buildTextField(_nomeController, "Nome Completo", hintStyle),
                const SizedBox(height: 15),
                _buildTextField(_emailController, "E-mail", hintStyle, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 15),
                _buildPasswordField(_senhaController, "Senha", _isPasswordObscured, () => setState(() => _isPasswordObscured = !_isPasswordObscured), hintStyle),
                const SizedBox(height: 15),
                _buildPasswordField(_confirmarSenhaController, "Confirmar Senha", _isConfirmPasswordObscured, () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured), hintStyle),

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.blue[400] : Colors.grey.shade800,
                    foregroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cadastrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextStyle style, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscured, VoidCallback toggle, TextStyle style) {
    return TextField(
      controller: controller,
      obscureText: obscured,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        suffixIcon: IconButton(
          icon: Icon(obscured ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }
}
