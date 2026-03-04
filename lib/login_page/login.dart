import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:condexpress/themes/theme_provider.dart';
import 'package:condexpress/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleManualLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar("Por favor, preencha e-mail e senha");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      String message = "Erro ao entrar";
      if (e.code == 'user-not-found') {
        message = "Usuário não encontrado";
      } else if (e.code == 'wrong-password') {
        message = "Senha incorreta";
      }
      _showSnackBar(message);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackBar("Erro: $e");
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        if (mounted) context.go('/home');
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar("Erro Google: $e");
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final hintStyle = TextStyle(
      fontSize: 18,
      color: Theme.of(context).textTheme.bodyLarge?.color?.withAlpha(153),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.nightlight_round : Icons.wb_sunny),
                  onPressed: () {
                    final newMode = themeProvider.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(newMode);
                  },
                ),
              ),
              Image.asset('assets/images/Icon.png', height: 300),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: hintStyle,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  hintText: "Senha",
                  hintStyle: hintStyle,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  suffixIcon: _passwordController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : () => context.go('/recuperar_senha'),
                  child: Text("Esqueceu a senha?", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18.0)),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleManualLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.blue[400] : Colors.grey.shade800,
                  foregroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : () => context.go('/cadastro'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.blue[400] : Colors.grey.shade800,
                  foregroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Criar Conta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                icon: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : Image.asset('assets/images/google.png', height: 24),
                label: Text(_isLoading ? 'Aguarde...' : 'Entrar com Google', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.themeMode == ThemeMode.light ? const Color.fromARGB(255, 230, 230, 230) : Colors.grey.shade800,
                  foregroundColor: themeProvider.themeMode == ThemeMode.light ? Colors.black : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: themeProvider.themeMode == ThemeMode.light ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
