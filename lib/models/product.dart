class Product {
  final String name;
  final List<String> sizes;
  final List<double> prices;
  final List<String>? sopa;
  final List<String>? bebida;
  final List<String>? fritura;
  final List<String>? bolsapapa;
  final List<String> extras;

  Product({
    required this.name,
    required this.sizes,
    required this.prices,
    this.sopa,
    this.bebida,
    this.fritura,
    this.bolsapapa,
    this.extras = const [],
  });

  // ✅ AGREGAR ESTOS MÉTODOS
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sizes': sizes,
      'prices': prices,
      'sopa': sopa,
      'bebida': bebida,
      'fritura': fritura,
      'bolsapapa': bolsapapa,
      'extras': extras,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      sizes: List<String>.from(json['sizes'] ?? []),
      prices: List<double>.from(json['prices'] ?? []),
      sopa: json['sopa'] != null ? List<String>.from(json['sopa']) : null,
      bebida: json['bebida'] != null ? List<String>.from(json['bebida']) : null,
      fritura: json['fritura'] != null ? List<String>.from(json['fritura']) : null,
      bolsapapa: json['bolsapapa'] != null ? List<String>.from(json['bolsapapa']) : null,
      extras: List<String>.from(json['extras'] ?? []),
    );
  }
}