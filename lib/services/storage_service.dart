import '../models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveOrderData(Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('extra', order.extra ?? 0.0);
    prefs.setDouble('costoEnvio', order.costoEnvio ?? 0.0);
    prefs.setDouble('pagoCliente', order.pagoCliente ?? 0.0);
  }

  static Future<Map<String, double>> loadOrderData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'extra': prefs.getDouble('extra') ?? 0.0,
      'costoEnvio': prefs.getDouble('costoEnvio') ?? 0.0,
      'pagoCliente': prefs.getDouble('pagoCliente') ?? 0.0,
    };
  }
}