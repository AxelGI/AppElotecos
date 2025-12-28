import '../models/product_order.dart';
import '../models/order.dart';

class OrderDetails {
  final String productName;
  final String productPrice;
  final String tipo;
  final String fritura;
  final String sopa;
  final String bebida;
  final String bolsaPapas;
  final String extras;
  final String especificaciones;
  final String costoEnvio;
  final String total;
  final String cambioCliente;
  final String pagoCliente;
  final String extra;
  final String orderDate;
  final String orderTime;
  final bool conTodo;
  final int cantidad;

  OrderDetails({
    required this.productName,
    required this.productPrice,
    required this.tipo,
    required this.fritura,
    required this.sopa,
    required this.bebida,
    required this.bolsaPapas,
    required this.extras,
    required this.especificaciones,
    required this.costoEnvio,
    required this.total,
    required this.cambioCliente,
    required this.pagoCliente,
    required this.extra,
    required this.orderDate,
    required this.orderTime,
    required this.conTodo,
    required this.cantidad,
  });

  factory OrderDetails.fromProductOrder(ProductOrder po, Order order) {
    return OrderDetails(
      productName: po.product.name,
      productPrice: '\$${po.totalPrice}',
      tipo: po.size,
      fritura: po.selectedFrituras.join("&"),
      sopa: po.selectedSopa ?? '',
      bebida: po.selectedBebida ?? '',
      bolsaPapas: po.selectedBolsapapas ?? '',
      extras: po.selectedExtras.join("&"),
      especificaciones: po.especificaciones ?? '',
      costoEnvio: '\$${order.costoEnvio ?? 0}',
      total: '\$${po.totalPrice}',
      cambioCliente: '',
      pagoCliente: '\$${order.pagoCliente ?? 0}',
      extra: '\$${order.extra ?? 0}',
      orderDate: '',
      orderTime: '',
      conTodo: po.withEverything,
      cantidad: po.cantidad,
    );
  }
}