import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../data/products_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderScreen(products: getProductsList()),
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: const Color(0xFFFDBC00),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDBC00),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFFDBC00)),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
          foregroundColor: Colors.black87,
        ),
      ),
    );
  }
}