import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/order.dart';

class OrderService {
  static Future<void> saveOrders(List<Order> orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ordersJson = jsonEncode(orders.map((order) => order.toJson()).toList());
    prefs.setString('orders', ordersJson);
  }

  static Future<List<Order>> loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersString = prefs.getString('orders');

    if (ordersString != null) {
      try {
        List<dynamic> decodedJson = jsonDecode(ordersString);
        return decodedJson.map((json) => Order.fromJson(json)).toList();
      } catch (e) {
        print("Error al deserializar las órdenes: $e");
        return [];
      }
    }
    return [];
  }

  static Future<void> saveOrderStatus(Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('order_${order.index}_status', order.status);
    prefs.setString('order_${order.index}_place', order.place);
  }

  static Future<void> loadOrderStatus(List<Order> orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (Order order in orders) {
      String place = prefs.getString('order_${order.index}_place') ?? 'Local';
      order.place = place;
      String status = prefs.getString('order_${order.index}_status') ?? 'Preparando';
      order.status = status;
    }
  }

  static Future<void> clearOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders');
  }

  static void toggleStatus(Order order, Function(void Function()) setState) async {
    setState(() {
      if (order.status == 'Preparando') {
        order.status = 'En mesa';
      } else if (order.status == 'En mesa') {
        order.status = 'Completa';
      } else if (order.status == 'Completa') {
        order.status = 'Preparando';
      }
      saveOrderStatus(order);
    });
  }

  static void togglePlace(Order order, Function(void Function()) setState) async {
    setState(() {
      if (order.place == 'Local') {
        order.place = 'Llevar';
      } else if (order.place == 'Llevar') {
        order.place = 'Envio';
      } else if (order.place == 'Envio') {
        order.place = 'Órale';
      } else if (order.place == 'Órale') {
        order.place = 'Express';
      } else {
        order.place = 'Local';
      }
      saveOrderStatus(order);
    });
  }
}