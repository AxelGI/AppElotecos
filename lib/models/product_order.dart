import 'product.dart';

class ProductOrder {
  Product product;
  String size;
  String? selectedSopa;
  List<String> selectedFrituras;
  String? selectedBolsapapas;
  String? selectedBebida;
  List<String> selectedExtras;
  String? especificaciones;
  bool withEverything;
  int cantidad;

  ProductOrder({
    required this.product,
    required this.size,
    this.selectedSopa,
    required this.selectedFrituras,
    this.selectedBolsapapas,
    this.selectedBebida,
    required this.selectedExtras,
    this.especificaciones,
    this.withEverything = false,
    this.cantidad = 1,
  });

  // ✅ CAMBIAR A double
  double get totalPrice {
    int sizeIndex = product.sizes.indexOf(size);
    double basePrice = sizeIndex != -1 ? product.prices[sizeIndex] * cantidad : 0.0;

    double extrasCost = selectedExtras.fold(0.0, (total, extra) {
      if (extra == 'volcano' || extra.startsWith('Cobertura')) {
        return total + 10.0 * cantidad;
      } else if (extra.startsWith('Porcion')) {
        return total + 25.0 * cantidad;
      } else if (extra.startsWith('Papa')) {
        return total + 20.0 * cantidad;
      }
      return total;
    });

    return basePrice + extrasCost;
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'size': size,
      'selectedSopa': selectedSopa,
      'selectedFrituras': selectedFrituras,
      'selectedBolsapapas': selectedBolsapapas,
      'selectedBebida': selectedBebida,
      'selectedExtras': selectedExtras,
      'especificaciones': especificaciones,
      'conTodo': withEverything,
      'cantidad': cantidad,
      'totalPrice': totalPrice, // Agregar para persistencia
    };
  }

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      product: Product.fromJson(json['product']),
      size: json['size'],
      selectedExtras: List<String>.from(json['selectedExtras']),
      selectedFrituras: List<String>.from(json['selectedFrituras']),
      selectedBolsapapas: json['selectedBolsapapas'],
      selectedBebida: json['selectedBebida'],
      selectedSopa: json['selectedSopa'],
      especificaciones: json['especificaciones'],
      withEverything: json['conTodo'] ?? false,
      cantidad: json['cantidad'] ?? 1,
    );
  }
}