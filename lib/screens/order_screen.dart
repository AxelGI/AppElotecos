import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/product_order.dart';
import '../screens/inventory_page.dart';
import '../screens/bluetooth_print_page.dart';
import '../services/order_service.dart';
import '../services/print_service.dart';
import '../widgets/order_card.dart';
import '../widgets/product_dialog.dart';
import '../widgets/order_summary_dialog.dart';
import '../utils/constants.dart';

class OrderScreen extends StatefulWidget {
  final List<Product> products;

  const OrderScreen({Key? key, required this.products}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orders = [];
  List<ProductOrder> selectedProductOrders = [];
  int? editedOrderIndex;
  bool _isBluetoothEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadOrders();
    await _checkBluetoothStatus();
  }

  Future<void> _checkBluetoothStatus() async {
    try {
      FlutterBlue flutterBlue = FlutterBlue.instance;
      bool isEnabled = await flutterBlue.isOn;
      setState(() {
        _isBluetoothEnabled = isEnabled;
      });
    } catch (e) {
      print("Error al obtener el estado de Bluetooth: $e");
    }
  }

  Future<bool> _requestBluetoothPermission() async {
    try {
      var status = await Permission.bluetooth.request();
      return status.isGranted;
    } catch (e) {
      print("Error al solicitar permiso de Bluetooth: $e");
      return false;
    }
  }

  Future<void> _loadOrders() async {
    List<Order> loadedOrders = await OrderService.loadOrders();
    setState(() {
      orders = loadedOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Elotecos",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_rounded),
            color: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InventoryPage(orders: orders),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            color: Colors.black87,
            onPressed: _showDeleteConfirmationDialog,
          ),
          IconButton(
            icon: const Icon(Icons.bluetooth_connected),
            color: _isBluetoothEnabled ? Colors.green : Colors.redAccent,
            onPressed: () async {
              bool hasPermission = await _requestBluetoothPermission();
              if (hasPermission) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BluetoothPrintPage()),
                );
              }
            },
          ),
        ],
      ),
      body: orders.isEmpty ? _buildEmptyState() : _buildOrderList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add, size: 45),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppMessages.noOrders,
            style: const TextStyle(fontSize: 35),
          ),
          const SizedBox(height: 16),
          Text(
            AppMessages.pressAdd,
            style: const TextStyle(fontSize: 35),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black87, size: 35),
              onPressed: () => _showProductDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 65),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        Order order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  bool _isEditingOrder = false;

  void _showProductDialog(BuildContext context, {VoidCallback? onComplete}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProductDialog(
        products: widget.products,
        onAddProduct: _addProduct,
        onViewOrder: () {
          Navigator.of(context).pop();
          _showOrderSummary(context, onComplete: onComplete);
        },
      ),
    );
  }

  void _showOrderSummary(BuildContext context, {VoidCallback? onComplete}) {
    if (selectedProductOrders.isEmpty) {
      _mostrarMensajeSinProductos();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrderSummaryDialog(
        productOrders: selectedProductOrders,
        onRemoveProduct: _removeProduct,
        onUpdateQuantity: _updateProductQuantity,
        onAddMoreProducts: () {
          Navigator.of(context).pop();
          _showProductDialog(context, onComplete: onComplete);
        },
        onCompleteOrder: () {
          Navigator.of(context).pop();

          if (onComplete != null) {
            onComplete();
          } else {
            _completeOrder();
          }

          setState(() {
            selectedProductOrders.clear();
            _isEditingOrder = false;
            editedOrderIndex = null;
          });
        },
        total: _calculateTotal(selectedProductOrders),
      ),
    );
  }

  void _addProduct(ProductOrder productOrder) {
    setState(() {
      selectedProductOrders.add(productOrder);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${productOrder.product.name} agregado'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _editOrder(Order orderToEdit) {
    setState(() {
      _isEditingOrder = true;
      editedOrderIndex = orderToEdit.index;
      selectedProductOrders = List.from(orderToEdit.productOrders);
      orders.removeWhere((o) => o.index == editedOrderIndex);
    });

    _sacarTotal(orderToEdit: orderToEdit);

  }


  void _showEditOptionsDialog(Order order, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.content_copy, color: Colors.green),
                title: const Text('Duplicar orden'),
                onTap: () {
                  Navigator.pop(context);
                  _duplicateOrder(order);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Eliminar orden'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteOrder(order);
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _duplicateOrder(Order originalOrder) {
    int newIndex = orders.isNotEmpty ? orders.last.index + 1 : 1;

    List<ProductOrder> copiedProductOrders = originalOrder.productOrders.map((po) {
      return ProductOrder(
        product: po.product,
        size: po.size,
        cantidad: po.cantidad,
        selectedExtras: List.from(po.selectedExtras),
        selectedFrituras: List.from(po.selectedFrituras),
        selectedSopa: po.selectedSopa,
        selectedBebida: po.selectedBebida,
        selectedBolsapapas: po.selectedBolsapapas,
        especificaciones: po.especificaciones,
        withEverything: po.withEverything,
      );
    }).toList();

    // CORRECCIÓN: Usar .toDouble() para convertir de int a double si es necesario
    Order newOrder = Order(
      index: newIndex,
      productOrders: copiedProductOrders,
      orderTime: DateTime.now(),
      place: originalOrder.place,
      status: 'Preparando',
      costoEnvio: (originalOrder.costoEnvio as num?)?.toDouble() ?? 0.0,
      extra: (originalOrder.extra as num?)?.toDouble() ?? 0.0,
      pagoCliente: (originalOrder.pagoCliente as num?)?.toDouble() ?? 0.0,
    );

    setState(() {
      orders.add(newOrder);
    });

    OrderService.saveOrders(orders);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orden #${newOrder.index} duplicada'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteOrder(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar orden'),
          content: Text('¿Estás seguro de eliminar la orden #${order.index}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  orders.remove(order);
                });
                OrderService.saveOrders(orders);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Orden #${order.index} eliminada'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onLongPress: () => _showEditOptionsDialog(order, context),
      child: OrderCard(
        order: order,
        onPrint: () => PrintService.printOrder(order),
        onEdit: () => _editOrder(order),
        setParentState: setState,
      ),
    );
  }

  void _sacarTotal({Order? orderToEdit}) {
    if ((orderToEdit == null && selectedProductOrders.isEmpty) ||
        (orderToEdit != null && orderToEdit.productOrders.isEmpty)) {
      _mostrarMensajeSinProductos();
      return;
    }

    List<ProductOrder> productOrders = orderToEdit?.productOrders ?? selectedProductOrders;
    double totalOrderPrice = _calculateTotal(productOrders);

    showDialog(
      context: context,
      builder: (context) => OrderSummaryDialog(
        productOrders: productOrders,
        onRemoveProduct: _removeProduct,
        onUpdateQuantity: _updateProductQuantity,
        onAddMoreProducts: () {
          Navigator.of(context).pop();
          _showProductDialog(context);
        },
        onCompleteOrder: () {
          Navigator.of(context).pop();
          _completeOrder(orderToEdit: orderToEdit);
        },
        total: totalOrderPrice,
      ),
    );
  }

  void _removeProduct(ProductOrder productOrder) {
    setState(() {
      selectedProductOrders.remove(productOrder);
    });
    Navigator.of(context).pop();
    _sacarTotal();
  }

  void _updateProductQuantity(ProductOrder productOrder, int newQuantity) {
    setState(() {
      productOrder.cantidad = newQuantity;
    });
    Navigator.of(context).pop();
    _sacarTotal();
  }

  // CORRECCIÓN: Cambiar 0 por 0.0
  double _calculateTotal(List<ProductOrder> productOrders) {
    return productOrders.fold(0.0, (total, po) => total + po.totalPrice);
  }

  void _mostrarMensajeSinProductos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppMessages.noProductsSelected),
          content: const Text(AppMessages.selectAtLeastOneProduct),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showProductDialog(context);
              },
              child: const Text(AppMessages.ok),
            ),
          ],
        );
      },
    );
  }

  void _completeOrder({Order? orderToEdit}) {
    int newIndex = editedOrderIndex ?? (orders.isNotEmpty ? orders.last.index + 1 : 1);

    Order order = Order(
      index: newIndex,
      productOrders: List.from(orderToEdit?.productOrders ?? selectedProductOrders),
      orderTime: DateTime.now(),
    );

    setState(() {
      if (editedOrderIndex != null) {
        int orderIndex = orders.indexWhere((o) => o.index == newIndex);
        if (orderIndex != -1) {
          orders[orderIndex] = order;
        } else {
          orders.add(order);
        }
        editedOrderIndex = null;
      } else {
        orders.add(order);
      }

      selectedProductOrders.clear();
    });

    OrderService.saveOrders(orders);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppMessages.deleteConfirmation),
          content: const Text(AppMessages.confirmDelete),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppMessages.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearOrders();
              },
              child: const Text(AppMessages.delete),
            ),
          ],
        );
      },
    );
  }

  void _clearOrders() async {
    await OrderService.clearOrders();
    setState(() {
      orders.clear();
    });
  }
}