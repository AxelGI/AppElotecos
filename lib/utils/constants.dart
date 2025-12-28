// utils/constants.dart (versión simple)
import 'package:flutter/material.dart';

// Listas
const List<String> frituras = ['chetos flamin\' hot', 'doritos', 'takis', 'ruffles'];
const List<String> extraslista = ['volcano', 'Porcion pastor','Porcion suadero','Porcion mixta', 'Papa cambray','Cobertura de Doritos ','Cobertura de Ruffles','Cobertura de Takis','Cobertura de Chtos flamin\' hot'];
const List<String> extrascarne = ['cebolla', 'cilantro','volcano', 'Porcion pastor','Porcion suadero','Porcion mixta', 'Papa cambray','Cobertura de Doritos ','Cobertura de Ruffles','Cobertura de Takis','Cobertura de Chtos flamin\' hot'];
const List<String> size = ['chico', 'grande'];

// Colores (como static final en lugar de const)
class AppColors {
  static const Color primary = Color(0xFFFDBC00);
  static const Color secondary = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.yellow;
  static const Color danger = Colors.redAccent;
  static const Color info = Colors.blue;
}

// Estilos de texto (como static final)
class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold
  );

  static const TextStyle orderNumber = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20
  );
}

class AppMessages {
  static const String noOrders = 'No hay órdenes.';
  static const String pressAdd = 'Presiona';
  static const String confirmDelete = '¿Seguro que quieres borrar todas las órdenes?';
  static const String deleteConfirmation = 'Confirmación';
  static const String cancel = 'Cancelar';
  static const String delete = 'Borrar';
  static const String noProductsSelected = 'Aún no has seleccionado productos';
  static const String selectAtLeastOneProduct = 'Regresa y selecciona al menos 1 producto para crear una orden';
  static const String ok = 'Vale';
  static const String howIsItGoing = '¿Cómo va, con todo?';
  static const String product = 'Producto:';
  static const String whatType = '¿De que tipo?:';
  static const String maruchanFlavor = '¿Sabor de Maruchan?';
  static const String drinkFlavor = '¿Sabor Bebida?';
  static const String whichCover = '¿Con que cubierta?';
  static const String whichBag = '¿Cuál bolsa papas?';
  static const String withEverything = 'Con todo';
  static const String specifications = 'Especificaciones';
  static const String enterDetails = 'Ingresa los detalles...';
  static const String extras = 'Extras:';
  static const String add = 'Agregar';
  static const String viewOrder = 'Ver orden';
  static const String currentOrder = 'Orden hasta el momento';
  static const String addMore = 'Agregar +';
  static const String finish = 'Terminar';
  static const String type = 'Tipo:';
  static const String fries = 'Frituras:';
  static const String soup = 'Sopa:';
  static const String drink = 'Bebida:';
  static const String potatoBag = 'Bolsa papa:';
  static const String details = 'Detalles:';
  static const String price = 'Precio:';
  static const String subtotal = 'Subtotal:';
  static const String shippingCost = 'Costo envío:';
  static const String extra = 'Extra:';
  static const String customerPayment = 'Pago cliente:';
  static const String change = 'Cambio:';
  static const String total = 'TOTAL:';
  static const String orderTaken = 'Tomada el';
  static const String atTime = 'a las';
  static const String deleteProduct = 'Borrar Producto de Orden';
  static const String deleteProductConfirmation = '¿Estás seguro de que deseas borrar este pedido?';
  static const String yesDelete = 'Sí, Borrar';
  static const String order = 'Orden';  // Agregar este
}