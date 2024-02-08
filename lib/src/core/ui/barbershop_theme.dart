import 'package:barbershop/src/core/ui/contants.dart';
import 'package:flutter/material.dart';

sealed class BarbershopTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    fontFamily: Constants.fontFamily,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(color: Constants.brow),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: Constants.fontFamily),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Constants.grey, fontSize: 16),
      border: _defaultInputborder,
      enabledBorder: _defaultInputborder,
      focusedBorder: _defaultInputborder,
      errorBorder: _defaultInputborder.copyWith(
          borderSide: const BorderSide(color: Constants.red)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.brow,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Constants.brow, width: 1),
        foregroundColor: Constants.brow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
  static const _defaultInputborder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Constants.grey),
  );
}
