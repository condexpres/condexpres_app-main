// Importa o pacote Material do Flutter para ter acesso ao ThemeData.
import 'package:flutter/material.dart';
// Importa o arquivo de cores personalizadas para usar as cores definidas para o tema escuro.
import 'app_color.dart';

// Define a configuração completa do tema escuro para o aplicativo.
ThemeData darkTheme = ThemeData(
  // Define o brilho geral do tema como escuro. Isso afeta a cor de componentes como barras de status.
    brightness: Brightness.dark,
    // Cor de fundo para elementos como o Drawer.
    canvasColor: AppColor.bodyColorDark,
    // Cor de fundo padrão para a maioria dos Scaffolds (telas).
    scaffoldBackgroundColor: AppColor.bodyColorDark,
    // Cor padrão para textos de dica (hintText) em campos como TextField.
    hintColor: AppColor.textColorDark,
    // Uma cor mais clara que a cor primária, aqui usada para o fundo de botões e cards.
    primaryColorLight: AppColor.buttonBackgroundColorDark,
    // Define os estilos de texto padrão para o aplicativo.
    textTheme: TextTheme(
      // Estilo para textos de grande destaque, como títulos principais.
        headlineLarge: TextStyle(
            color: Colors.white, // Cor do texto.
            fontSize: 40, // Tamanho da fonte.
            fontWeight: FontWeight.bold // Peso da fonte (negrito).
        ),
        // Estilo padrão para o corpo do texto.
        bodyLarge: TextStyle(
            color: AppColor.textColorDark, // Cor do texto.
            fontWeight: FontWeight.bold // Peso da fonte (negrito).
        )
    ),
    // Define as configurações padrão para widgets de botão.
    buttonTheme: ButtonThemeData(
      // Define que o texto do botão usará a cor primária do tema de texto.
        textTheme: ButtonTextTheme.primary,
        // Cor de fundo para botões.
        buttonColor: Colors.white
    )
);