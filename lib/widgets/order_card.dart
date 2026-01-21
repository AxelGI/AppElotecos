import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../models/product_order.dart';
import '../services/order_service.dart';
import '../utils/constants.dart';
import '../widgets/order_cost_fields.dart';
import 'edit_product_dialog.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback onPrint;
  final VoidCallback onEdit;
  final Function(void Function()) setParentState;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onPrint,
    required this.onEdit,
    required this.setParentState,
  }) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    // Si la orden está completada, empezar encogida
    if (widget.order.status == 'Completado' || widget.order.status == 'Completa') {
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.order.status == 'Completado' || widget.order.status == 'Completa';

    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: isCompleted ? 1 : 4, // Menos elevación si está completada
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildOrderHeader(isCompleted),
          if (_isExpanded) _buildOrderBody(isCompleted),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[700] : Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '#${widget.order.index}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isCompleted ? 18 : 20,
            ),
          ),

          Row(
            children: [
              _buildStatusButton(),
              const SizedBox(width: 8),
              if (!isCompleted) _buildPlaceButton(),
            ],
          ),

          // Botón para expandir/contraer
          IconButton(
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
              size: isCompleted ? 24 : 28,
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton() {
    return ElevatedButton(
      onPressed: () => OrderService.toggleStatus(widget.order, widget.setParentState),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getStatusColor(widget.order.status),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(
        widget.order.status,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildPlaceButton() {
    return ElevatedButton(
      onPressed: () => OrderService.togglePlace(widget.order, widget.setParentState),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getPlaceColor(widget.order.place),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(
        widget.order.place,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildOrderBody(bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostrar fecha/hora más compacta si está completado
          Text(
            '${AppMessages.orderTaken} ${DateFormat('dd-MM-yy').format(widget.order.orderTime)} '
                '${AppMessages.atTime} ${DateFormat('HH:mm').format(widget.order.orderTime)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isCompleted ? 14 : 16,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de productos más compacta si está completado
          if (isCompleted)
            Text(
              '${widget.order.productOrders.length} producto(s) - \$${widget.order.total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          else
            ...widget.order.productOrders.map(_buildProductItem),

          const SizedBox(height: 12),

          // Mostrar campos de costo solo si no está completado
          if (!isCompleted) OrderCostFields(order: widget.order, setParentState: widget.setParentState),

          const SizedBox(height: 12),

          // Resumen de orden (siempre visible)
          _buildOrderSummary(isCompleted),

          // NUEVO: Botón para cambiar estado incluso cuando está completada
          if (isCompleted) ...[
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Cambiar estado de "Completado" a "Preparando"
                  OrderService.setStatus(widget.order, 'Preparando', widget.setParentState);
                  // Opcional: Expandir automáticamente
                  setState(() {
                    _isExpanded = true;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reactivar orden'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],

          // Botones de acción solo si no está completado
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: widget.onPrint,
                  icon: const Icon(Icons.print),
                  label: const Text('Imprimir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductOrder productOrder) {
    return InkWell(
      onTap: () {
        // Mostrar dialog para editar este producto específico
        _showEditProductDialog(productOrder);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'x${productOrder.cantidad} ${productOrder.product.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () => _showEditProductDialog(productOrder),
                  ),
                ],
              ),
              Text(
                '\$${productOrder.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (productOrder.size.isNotEmpty)
            Text('${AppMessages.type} ${productOrder.size}', style: TextStyle(fontSize: 14)),
          if (productOrder.selectedSopa != null)
            Text('${AppMessages.soup} ${productOrder.selectedSopa}', style: TextStyle(fontSize: 14)),
          if (productOrder.selectedBebida != null)
            Text('${AppMessages.drink} ${productOrder.selectedBebida}', style: TextStyle(fontSize: 14)),
          if (productOrder.selectedFrituras.isNotEmpty)
            Text('${AppMessages.fries} ${productOrder.selectedFrituras.join(", ")}', style: TextStyle(fontSize: 14)),
          if (productOrder.selectedBolsapapas != null)
            Text('Bolsa de papas: ${productOrder.selectedBolsapapas}', style: TextStyle(fontSize: 14)),
          if (productOrder.especificaciones != null && productOrder.especificaciones!.isNotEmpty)
            Text('${AppMessages.details} ${productOrder.especificaciones}', style: TextStyle(fontSize: 14)),
          if (productOrder.withEverything)
            const Text(AppMessages.withEverything, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(bool isCompleted) {
    // Calcular subtotal
    double subtotal = widget.order.productOrders.fold(0, (sum, po) => sum + po.totalPrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCompleted) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          if (widget.order.extra != null && widget.order.extra! > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Extra:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${widget.order.extra!.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          if (widget.order.costoEnvio != null && widget.order.costoEnvio! > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Costo envío:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${widget.order.costoEnvio!.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          const Divider(),
        ],

        // Total siempre visible
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL:',
              style: TextStyle(
                  fontSize: isCompleted ? 16 : 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '\$${widget.order.total.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: isCompleted ? 16 : 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),

        if (widget.order.pagoCliente != null && widget.order.pagoCliente! > 0 && !isCompleted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pago cliente:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${widget.order.pagoCliente!.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        if (widget.order.cambioCliente != null && !isCompleted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cambio:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${widget.order.cambioCliente}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
      ],
    );
  }

  void _showEditProductDialog(ProductOrder productOrder) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        productOrder: productOrder,
        onSave: (updatedProductOrder) {
          // CORRECCIÓN: No necesitas buscar en orders, solo en esta orden
          final productIndex = widget.order.productOrders.indexOf(productOrder);
          if (productIndex != -1) {
            // Solo actualiza esta orden específica
            widget.order.productOrders[productIndex] = updatedProductOrder;
            widget.setParentState(() {});
          }
        },
        onDelete: () {
          widget.order.productOrders.remove(productOrder);
          widget.setParentState(() {});
          Navigator.pop(context);
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Preparando': return Colors.yellow;
      case 'Completa': return Colors.lightGreen;
      case 'Listo': return Colors.lightGreen;
      default: return Colors.deepOrangeAccent;
    }
  }

  Color _getPlaceColor(String place) {
    switch (place) {
      case 'Local': return Colors.yellow;
      case 'Llevar': return Colors.orangeAccent;
      case 'Envio': return Colors.redAccent;
      case 'Órale': return Colors.green;
      default: return Colors.yellow;
    }
  }
}