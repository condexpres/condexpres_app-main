import 'package:condexpress/screen_costumers/local_page.dart';
import 'package:condexpress/screen_costumers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'cadastro_page/cadastro_page.dart';
import 'home.dart';
import 'login_page/login.dart';
import 'recover_senha/recuperar_senha.dart';
import 'themes/app_theme.dart';
import 'themes/theme_provider.dart';
import 'alteracao_senha/trocar_senha.dart';
import 'package:condexpress/screen_costumers/costumers_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialização básica do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'CondExpress',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: GoRouter(
              initialLocation: '/login',
              routes: [
                GoRoute(
                  path: '/login',
                  builder: (context, state) => const LoginPage(),
                ),
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomePage(),
                ),
                GoRoute(
                  path: '/cadastro',
                  builder: (context, state) => const CadastroPage(),
                ),
                GoRoute(
                  path: '/recuperar_senha',
                  builder: (context, state) => const RecuperarSenha(),
                ),
                GoRoute(
                  path: '/trocar_senha',
                  builder: (context, state) => const TrocaSenhaPage(),
                ),
                GoRoute(
                  path: '/costumers',
                  builder: (context, state) => const CostumersPage(),
                ),
                GoRoute(
                  path: '/notifications',
                  builder: (context, state) => const NotificationsPage(),
                ),
                GoRoute(
                  path: '/local_page',
                  builder: (context, state) => const LocalPage(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
