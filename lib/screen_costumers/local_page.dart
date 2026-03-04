import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const LocalPage());
}

class LocalPage extends StatefulWidget {
  const LocalPage({super.key});
  @override
  State<LocalPage> createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/costumers'); // Redireciona para a tela de costumers
            }
          },
        ),
      ),
    );
  }
}
