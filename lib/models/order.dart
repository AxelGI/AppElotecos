import 'product_order.dart';
import 'dart:convert';

class Order {
  int index;
  List<ProductOrder> productOrders;
  DateTime orderTime;
  String place;
  String status;
  double? costoEnvio;
  double? extra;
  double? pagoCliente;
  String? cambioCliente; // Cambiado a String para mantener formato

  Order({
    required this.index,
    required this.productOrders,
    required this.orderTime,
    this.place = 'Local',
    this.status = 'Preparando',
    this.costoEnvio = 0,
    this.extra = 0,
    this.pagoCliente = 0,
    this.cambioCliente = '0.00',
  });

  // ✅ GETTERS IMPORTANTES
  double get subtotal {
    return productOrders.fold(0.0, (sum, po) => sum + po.totalPrice);
  }

  double get total {
    return subtotal + (costoEnvio ?? 0) + (extra ?? 0);
  }

  bool get isDomicilio => place == 'Envio' || place == 'Express';

  // Método para actualizar el cambio
  void updateChange() {
    if (pagoCliente != null) {
      cambioCliente = (pagoCliente! - total).toStringAsFixed(2);
    } else {
      cambioCliente = '0.00';
    }
  }

  // Método para calcular total
  double calculateTotal() {
    return subtotal + (costoEnvio ?? 0) + (extra ?? 0);
  }

  // Métodos para serialización/deserialización
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'productOrders': productOrders.map((po) => po.toJson()).toList(),
      'orderTime': orderTime.toIso8601String(),
      'place': place,
      'status': status,
      'costoEnvio': costoEnvio,
      'extra': extra,
      'pagoCliente': pagoCliente,
      'cambioCliente': cambioCliente,
    };
  }

  // Factory constructor para crear Order desde JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      index: json['index'] ?? 0,
      productOrders: (json['productOrders'] as List)
          .map((po) => ProductOrder.fromJson(po))
          .toList(),
      orderTime: DateTime.parse(json['orderTime'] ?? DateTime.now().toIso8601String()),
      place: json['place'] ?? 'Local',
      status: json['status'] ?? 'Preparando',
      costoEnvio: (json['costoEnvio'] as num?)?.toDouble() ?? 0.0,
      extra: (json['extra'] as num?)?.toDouble() ?? 0.0,
      pagoCliente: (json['pagoCliente'] as num?)?.toDouble() ?? 0.0,
      cambioCliente: json['cambioCliente']?.toString() ?? '0.00',
    );
  }

  // Método estático para convertir lista de órdenes a JSON
  static String listToJson(List<Order> orders) {
    return jsonEncode(orders.map((order) => order.toJson()).toList());
  }

  // Método estático para crear lista de órdenes desde JSON
  static List<Order> listFromJson(String jsonString) {
    try {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print("Error al decodificar órdenes: $e");
      return [];
    }
  }

  // Métodos de utilidad
  void addProductOrder(ProductOrder productOrder) {
    productOrders.add(productOrder);
  }

  void removeProductOrder(ProductOrder productOrder) {
    productOrders.remove(productOrder);
  }

  void clearProductOrders() {
    productOrders.clear();
  }

  // Método para clonar la orden (útil para edición)
  Order copyWith({
    int? index,
    List<ProductOrder>? productOrders,
    DateTime? orderTime,
    String? place,
    String? status,
    double? costoEnvio,
    double? extra,
    double? pagoCliente,
    String? cambioCliente,
  }) {
    return Order(
      index: index ?? this.index,
      productOrders: productOrders ?? List.from(this.productOrders),
      orderTime: orderTime ?? this.orderTime,
      place: place ?? this.place,
      status: status ?? this.status,
      costoEnvio: costoEnvio ?? this.costoEnvio,
      extra: extra ?? this.extra,
      pagoCliente: pagoCliente ?? this.pagoCliente,
      cambioCliente: cambioCliente ?? this.cambioCliente,
    );
  }

  // Método para verificar si la orden está vacía
  bool get isEmpty => productOrders.isEmpty;

  // Método para obtener cantidad total de productos
  int get totalCantidad {
    return productOrders.fold(0, (sum, po) => sum + po.cantidad);
  }

  @override
  String toString() {
    return 'Order #$index: ${productOrders.length} productos, Total: \$${total.toStringAsFixed(2)}';
  }
}