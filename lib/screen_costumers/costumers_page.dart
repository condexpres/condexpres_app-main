import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:condexpress/themes/theme_provider.dart';

void main() {
  runApp(const CostumersPage());
}

class CostumersPage extends StatefulWidget {
  const CostumersPage({super.key});

  @override
  State<CostumersPage> createState() => _CostumersPageState();
}

class _CostumersPageState extends State<CostumersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 110),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/local_page'),
            icon: const Icon(Icons.location_on),
            label: Text('Minha Localização'),
            style: TextButton.styleFrom(
              foregroundColor:
                  Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            context.go('/notifications');
          },
        ),
      ),
    );
  }
}
