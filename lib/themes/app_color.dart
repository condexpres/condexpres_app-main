// Importa o pacote Material do Flutter, que contém widgets e a classe Color.
import 'package:flutter/material.dart';

// A classe AppColor serve como um local centralizado para definir as cores do aplicativo.
class AppColor {
  // Cor do texto para o tema claro.
  static Color textColor = const Color(0xff9C9C9D);
  // Cor do texto para o tema escuro.
  static Color textColorDark = const Color(0xffffffff);

  // Cor de fundo principal (corpo) para o tema claro.
  static Color bodyColor = const Color(0xffffffff);
  // Cor de fundo principal (corpo) para o tema escuro.
  static Color bodyColorDark = const Color(0xff0E0E0F);

  // Cor de fundo para botões e outros elementos interativos no tema claro.
  static Color buttonBackgroundColor = const Color(0xffF7F7F7);
  // Cor de fundo para botões e outros elementos interativos no tema escuro.
  static Color buttonBackgroundColorDark = const Color(0xff121212);
}