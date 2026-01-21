import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../models/product_order.dart';

class OrderDetailsWidget extends StatelessWidget {
  final Order order;

  const OrderDetailsWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 6),
        Text(
          'Tomada el ${DateFormat('dd-MM-yy').format(order.orderTime)} a las ${DateFormat('HH:mm').format(order.orderTime)}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: order.productOrders.asMap().entries.map((entry) {
            ProductOrder productOrder = entry.value;
            return _buildProductOrderItem(productOrder);
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Divider(),
        _buildSubtotal(order),
      ],
    );
  }

  Widget _buildProductOrderItem(ProductOrder productOrder) {
    int sizeIndex = productOrder.product.sizes.indexOf(productOrder.size);
    double price = sizeIndex != -1 ? productOrder.product.prices[sizeIndex] * productOrder.cantidad : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'x${productOrder.cantidad} ${productOrder.product.name}',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
            Container(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
            ),
          ],
        ),

        Text('Tipo: ${productOrder.size}', style: const TextStyle(color: Colors.black)),

        if (productOrder.selectedSopa != null && productOrder.selectedSopa!.isNotEmpty)
          Text('Sopa: ${productOrder.selectedSopa}', style: const TextStyle(color: Colors.black)),

        if (productOrder.selectedBebida != null && productOrder.selectedBebida!.isNotEmpty)
          Text('Bebida: ${productOrder.selectedBebida}', style: const TextStyle(color: Colors.black)),

        if (productOrder.selectedFrituras.isNotEmpty)
          Text('Fritura: ${productOrder.selectedFrituras.join(", ")}', style: const TextStyle(color: Colors.black)),

        if (productOrder.selectedBolsapapas != null && productOrder.selectedBolsapapas!.isNotEmpty)
          Text('Bolsa de papas: ${productOrder.selectedBolsapapas}', style: const TextStyle(color: Colors.black)),

        if (productOrder.especificaciones != null && productOrder.especificaciones!.isNotEmpty)
          Text('Especificaciones: ${productOrder.especificaciones}', style: const TextStyle(color: Colors.black)),

        if (productOrder.withEverything)
          const Text('Con todo', style: TextStyle(fontWeight: FontWeight.bold)),

        if (productOrder.selectedExtras.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Extras: ${productOrder.selectedExtras.join(", ")}', style: const TextStyle(color: Colors.black)),
              ...productOrder.selectedExtras.map((extra) {
                double extraCost = _calculateExtraCost(extra, productOrder.cantidad);
                return extraCost > 0
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' - $extra', style: const TextStyle(color: Colors.black)),
                    Container(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        '\$${extraCost.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
                    : const SizedBox();
              }),
            ],
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSubtotal(Order order) {
    double subtotal = order.subtotal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Subtotal: \$${subtotal.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  // Cambiar de int a double
  double _calculateExtraCost(String extra, int cantidad) {
    if (extra == 'volcano' || extra.startsWith('Cobertura')) {
      return 10.0 * cantidad;
    } else if (extra.startsWith('Porcion')) {
      return 25.0 * cantidad;
    } else if (extra.startsWith('Papa')) {
      return 20.0 * cantidad;
    }
    return 0.0;
  }
}