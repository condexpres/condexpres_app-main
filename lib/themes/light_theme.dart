// Importa o pacote Material do Flutter para ter acesso ao ThemeData.
import 'package:flutter/material.dart';
// Importa o arquivo de cores personalizadas para usar as cores definidas para o tema claro.
import 'app_color.dart';

// Define a configuração completa do tema claro para o aplicativo.
ThemeData lightTheme = ThemeData(
  // Define o brilho geral do tema como claro. Isso afeta componentes como a barra de status.
    brightness: Brightness.light,
    // Cor de fundo para elementos como o Drawer.
    canvasColor: AppColor.bodyColor,
    // Cor de fundo padrão para a maioria dos Scaffolds (telas).
    scaffoldBackgroundColor: AppColor.bodyColor,
    // Cor padrão para textos de dica (hintText) em campos como TextField.
    hintColor: AppColor.textColor,
    // Uma cor mais clara que a cor primária, usada aqui para o fundo de botões e cards.
    primaryColorLight: AppColor.buttonBackgroundColor,
    // Define os estilos de texto padrão para o aplicativo.
    textTheme: TextTheme(
      // Estilo para textos de grande destaque, como títulos principais.
        headlineLarge: TextStyle(
            color: Colors.black, // Cor do texto.
            fontSize: 40, // Tamanho da fonte.
            fontWeight: FontWeight.bold // Peso da fonte (negrito).
        ),
        // Estilo padrão para o corpo do texto.
        bodyLarge: TextStyle(
            color: Colors.black, // Cor do texto.
            fontSize: 20, // Tamanho da fonte.
            fontWeight: FontWeight.bold // Peso da fonte (negrito).
        )
    ),
    // Define as configurações padrão para widgets de botão.
    buttonTheme: ButtonThemeData(
      // Define que o texto do botão usará a cor primária do tema de texto.
        textTheme: ButtonTextTheme.primary,
        // Cor de fundo para botões.
        buttonColor: Colors.black
    )
);