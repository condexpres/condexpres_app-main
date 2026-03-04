import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condexpress/themes/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrocaSenhaPage extends StatefulWidget {
  const TrocaSenhaPage({super.key});

  @override
  State<TrocaSenhaPage> createState() => _TrocaSenhaPageState();
}

class _TrocaSenhaPageState extends State<TrocaSenhaPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final hintStyle = TextStyle(fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // --- CORREÇÃO AQUI ---
          // Verifica se pode voltar. Se sim, volta. Se não, vai para o login.
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login'); // Redireciona para a tela de login
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
            ),
            onPressed: () {
              final newMode = themeProvider.themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).setThemeMode(newMode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/Icon.png',
                          height: size.height * 0.2,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Esqueceu a Senha ?',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Insira seu e-mail para redefinir sua senha ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "E-mail",
                            hintStyle: hintStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 260),
                      ElevatedButton(
                        onPressed: () {
                          _enviarTokenPeloPython(_emailController.text);
                          context.go(
                            '/codigo-email',
                            extra: _emailController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              themeProvider.themeMode == ThemeMode.light
                              ? Colors.blue[400]
                              : Colors.grey.shade800,

                          foregroundColor:
                              themeProvider.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,

                          elevation: 0,
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Enviar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: themeProvider.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _enviarTokenPeloPython(String email) async {
    // ATENÇÃO: Mude este URL se estiver usando um celular físico
    final String url = 'http://10.0.2.2:5000/enviar-token';

    debugPrint('Iniciando envio de e-mail para $email...');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Sucesso! Resposta da API: ${responseBody['mensagem']}');
      } else {
        final responseBody = jsonDecode(response.body);
        debugPrint('Erro! Resposta da API: ${responseBody['mensagem']}');
      }
    } catch (e) {
      debugPrint('Uma exceção do Dart ocorreu: $e');
    }
  }
}
