import 'package:flutter/material.dart';
import '../models/product_order.dart';
import '../utils/constants.dart';
import 'edit_product_dialog.dart';

class OrderSummaryDialog extends StatelessWidget {
  final List<ProductOrder> productOrders;
  final Function(ProductOrder) onRemoveProduct;
  final Function(ProductOrder, int) onUpdateQuantity;
  final Function() onAddMoreProducts;
  final Function() onCompleteOrder;
  final double total;

  const OrderSummaryDialog({
    Key? key,
    required this.productOrders,
    required this.onRemoveProduct,
    required this.onUpdateQuantity,
    required this.onAddMoreProducts,
    required this.onCompleteOrder,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppMessages.currentOrder),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (ProductOrder productOrder in productOrders)
              _buildProductSummary(productOrder, context),
            const Divider(thickness: 5),
            Text(
              '${AppMessages.total}: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: onAddMoreProducts,
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(AppMessages.addMore, style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: onCompleteOrder,
              style: TextButton.styleFrom(backgroundColor: Colors.yellow),
              child: const Text(AppMessages.finish, style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductSummary(ProductOrder productOrder, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DropdownButton<int>(
              value: productOrder.cantidad,
              items: List.generate(10, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text('x$value'),
              ))
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onUpdateQuantity(productOrder, newValue);
                }
              },
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  // Mostrar dialog de edición
                  _showEditProductDialog(productOrder, context);
                },
                child: Text(
                  productOrder.product.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              onPressed: () => onRemoveProduct(productOrder),
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              tooltip: AppMessages.deleteProduct,
            ),
            IconButton(
              onPressed: () => _showEditProductDialog(productOrder, context),
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Editar producto',
            ),
          ],
        ),

        Text('${AppMessages.type} ${productOrder.size}',
            style: const TextStyle(fontSize:18)),

        if (productOrder.selectedFrituras.isNotEmpty)
          Text('${AppMessages.fries} ${productOrder.selectedFrituras.join(', ')}',
              style: const TextStyle(fontSize:18)),

        if (productOrder.selectedSopa != null && productOrder.selectedSopa!.isNotEmpty)
          Text('${AppMessages.soup} ${productOrder.selectedSopa}',
              style: const TextStyle(fontSize: 18)),

        if (productOrder.selectedBebida != null && productOrder.selectedBebida!.isNotEmpty)
          Text('${AppMessages.drink} ${productOrder.selectedBebida}',
              style: const TextStyle(fontSize: 18)),

        if (productOrder.selectedBolsapapas != null && productOrder.selectedBolsapapas!.isNotEmpty)
          Text('${AppMessages.potatoBag} ${productOrder.selectedBolsapapas}',
              style: const TextStyle(fontSize: 18)),

        if (productOrder.selectedExtras.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: productOrder.selectedExtras.map((extra) {
              double extraCost = _calculateExtraCost(extra, productOrder.cantidad);
              return Text(
                '$extra: \$$extraCost',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              );
            }).toList(),
          ),

        if (productOrder.especificaciones != null && productOrder.especificaciones!.isNotEmpty)
          Text('${AppMessages.details} ${productOrder.especificaciones}',
              style: const TextStyle(fontSize: 18)),

        if (productOrder.withEverything)
          const Text(AppMessages.withEverything,
              style: TextStyle(fontSize: 18)),

        Text(
          '${AppMessages.price}: \$${productOrder.totalPrice}',
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

// En OrderSummaryDialog, cambia _showEditProductDialog:
  void _showEditProductDialog(ProductOrder productOrder, BuildContext dialogContext) {
    // Usar dialogContext en lugar de context
    showDialog(
      context: dialogContext,
      builder: (context) => EditProductDialog(
        productOrder: productOrder,
        onSave: (updatedProductOrder) {
          final index = productOrders.indexOf(productOrder);
          if (index != -1) {
            productOrders[index] = updatedProductOrder;
            // Necesitamos notificar al padre
            onUpdateQuantity(updatedProductOrder, updatedProductOrder.cantidad);
          }
        },
        onDelete: () {
          onRemoveProduct(productOrder);
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  double _calculateExtraCost(String extra, int cantidad) {
    if (extra == 'volcano' || extra.startsWith('Cobertura')) {
      return 10.0 * cantidad;
    } else if (extra.startsWith('Porcion')) {
      return 25.0 * cantidad;
    } else if (extra.startsWith('Papa')) {
      return 20.0 * cantidad;
    }
    return 0;
  }
}