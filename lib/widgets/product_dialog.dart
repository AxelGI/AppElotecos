import 'package:flutter/material.dart';
import '../models/product.dart';  // Importa el modelo
import '../models/product_order.dart';

class ProductDialog extends StatefulWidget {  final List<Product> products;
final Function(ProductOrder) onAddProduct;
final Function() onViewOrder;

const ProductDialog({
  Key? key,
  required this.products,
  required this.onAddProduct,
  required this.onViewOrder,
}) : super(key: key);

@override
_ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  Product? selectedProduct;
  String selectedSize = '';
  List<String> selectedExtras = [];
  List<String> selectedFrituras = [];
  String? selectedBolsapapas;
  String? selectedSopa;
  String? selectedBebida;
  bool withEverything = false;
  TextEditingController especificacionesController = TextEditingController();
  bool presionameSelected = false; // Nueva variable para controlar el estado

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Cómo va, con todo?'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductList(),
            if (selectedProduct != null && selectedProduct!.sizes.isNotEmpty)
              _buildSizeSelection(),
            if (selectedProduct?.sopa != null) _buildSopaSelection(),
            if (selectedProduct?.bebida != null) _buildBebidaSelection(),
            if (_showFrituraSection()) _buildFrituraSelection(),
            if (_showBolsapapaSection()) _buildBolsapapaSelection(),
            if (selectedProduct != null) _buildConTodoCheckbox(),
            if (selectedProduct != null && !withEverything)
              _buildEspecificaciones(),
            if (selectedProduct != null && selectedProduct!.extras.isNotEmpty)
              _buildExtrasSelection(),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: _canAddProduct() ? _addProduct : null,
              style: TextButton.styleFrom(
                backgroundColor: _canAddProduct() ? Colors.green : Colors.grey,
              ),
              child: const Text('Agregar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: widget.onViewOrder,
              style: TextButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Ver orden', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildProductList() {
    // Si presionameSelected es false, mostrar solo "Presioname"
    if (!presionameSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Producto:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          // Mostrar solo "Presioname"
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.products
                .where((product) => product.name == 'Presioname')
                .map((product) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    presionameSelected = true; // Activar modo de selección
                    selectedProduct = null; // No seleccionar producto aún
                    // Limpiar todas las selecciones anteriores
                    selectedSize = '';
                    selectedExtras.clear();
                    selectedFrituras.clear();
                    selectedBolsapapas = null;
                    selectedSopa = null;
                    selectedBebida = null;
                    withEverything = false;
                    especificacionesController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: Text(
                  product.name,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    // Si presionameSelected es true pero no hay producto seleccionado, mostrar todos menos "Presioname"
    if (selectedProduct == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    presionameSelected = false; // Regresar a vista inicial
                    selectedProduct = null;
                    selectedSize = '';
                    selectedExtras.clear();
                    selectedFrituras.clear();
                    selectedBolsapapas = null;
                    selectedSopa = null;
                    selectedBebida = null;
                    withEverything = false;
                    especificacionesController.clear();
                  });
                },
              ),
              const Text('Selecciona un producto:', style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.products.where((product) => product.name != 'Presioname').map((product) {
              Color buttonColor = _determineButtonColor(product);

              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedProduct = product; // Seleccionar el producto real
                    selectedSize = product.sizes.isNotEmpty ? product.sizes[0] : '';
                    selectedExtras.clear();
                    selectedFrituras.clear();
                    selectedBolsapapas = null;
                    selectedSopa = null;
                    selectedBebida = null;
                    withEverything = false;
                    especificacionesController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
                child: Text(
                  product.name,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    // Si hay un producto seleccionado, mostrar solo su nombre
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  selectedProduct = null; // Volver a la lista de productos
                  selectedSize = '';
                  selectedExtras.clear();
                  selectedFrituras.clear();
                  selectedBolsapapas = null;
                  selectedSopa = null;
                  selectedBebida = null;
                  withEverything = false;
                  especificacionesController.clear();
                });
              },
            ),
            const Text('Producto seleccionado:', style: TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedProduct = null; // Deseleccionar para volver a la lista
              selectedSize = '';
              selectedExtras.clear();
              selectedFrituras.clear();
              selectedBolsapapas = null;
              selectedSopa = null;
              selectedBebida = null;
              withEverything = false;
              especificacionesController.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _determineButtonColor(selectedProduct!),
          ),
          child: Text(
            selectedProduct!.name,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('¿De que tipo?:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedProduct!.sizes.map((size) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedSize = size;
                  if (size == 'natural') {
                    selectedSopa = null;
                    selectedFrituras.clear();
                    selectedBolsapapas = null;
                  } else if (size == 'loco') {
                    selectedBolsapapas = null;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSize == size ? Colors.green : Colors.grey,
              ),
              child: Text(size),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSopaSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('¿Sabor de Maruchan?', style: TextStyle(fontSize: 18)), // ← Quitar validación visual
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedProduct!.sopa!.map((sopa) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedSopa = sopa;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSopa == sopa ? Colors.green : Colors.grey,
              ),
              child: Text(sopa),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBebidaSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('¿Sabor Bebida?', style: TextStyle(fontSize: 18)), // ← Quitar validación visual
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedProduct!.bebida!.map((bebida) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedBebida = bebida;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedBebida == bebida ? Colors.green : Colors.grey,
              ),
              child: Text(bebida),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFrituraSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('¿Con que cubierta?', style: TextStyle(fontSize: 18)), // ← Quitar validación visual
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedProduct!.fritura!.map((option) {
            return FilterChip(
              label: Text(option, style: const TextStyle(color: Colors.white)),
              backgroundColor: selectedFrituras.contains(option) ? Colors.green : Colors.black38,
              selected: selectedFrituras.contains(option),
              selectedColor: Colors.green,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedFrituras.add(option);
                  } else {
                    selectedFrituras.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBolsapapaSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('¿Cuál bolsa papas?', style: TextStyle(fontSize: 18)), // ← Quitar validación visual
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedProduct!.bolsapapa!.map((bolsapapa) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedBolsapapas = bolsapapa;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedBolsapapas == bolsapapa ? Colors.green : Colors.grey,
              ),
              child: Text(bolsapapa),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConTodoCheckbox() {
    return CheckboxListTile(
      title: const Text('Con todo'),
      value: withEverything,
      onChanged: (value) {
        setState(() {
          withEverything = value ?? false;
          if (withEverything) {
            especificacionesController.clear();
          }
        });
      },
    );
  }

  Widget _buildEspecificaciones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: especificacionesController,
          decoration: const InputDecoration(
            labelText: 'Especificaciones',
            border: OutlineInputBorder(),
            hintText: 'Ingresa los detalles...',
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildExtrasSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Extras:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedProduct!.extras.map((extra) {
            return FilterChip(
              label: Text(extra, style: const TextStyle(color: Colors.white)),
              backgroundColor: selectedExtras.contains(extra) ? Colors.green : Colors.black38,
              selected: selectedExtras.contains(extra),
              selectedColor: Colors.green,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedExtras.add(extra);
                  } else {
                    selectedExtras.remove(extra);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _determineButtonColor(Product product) {
    if (product.name.contains('Banderilla') || product.name.contains('frances')) {
      return Colors.red;
    } else if (product.name.contains('Bebida') ||
        product.name.contains('Arizona') ||
        product.name.contains('Refrescos') ||
        product.name.contains('Clamateco') ||
        product.name.contains('Boing') ||
        product.name.contains('Patibebida') ||
        product.name.contains('Agua')) {
      return Colors.blue;
    } else {
      return Colors.yellow;
    }
  }

  bool _showFrituraSection() {
    return selectedProduct?.fritura != null &&
        ((selectedSize == 'papalote') ||
            (selectedSize == 'loco') ||
            (selectedSize == 'fritura') ||
            (selectedSize == 'esquite y fritura') ||
            (selectedSize == 'esquisopa loca') ||
            (selectedProduct?.name == 'Esquite loco') ||
            (selectedProduct?.name == 'Papa esquite') ||
            (selectedProduct?.name == 'Banderilla salada') ||
            (selectedProduct?.name == 'Arizona loco') ||
            (selectedProduct?.name == 'Costillitas'));
  }

  bool _showBolsapapaSection() {
    return selectedProduct?.bolsapapa != null &&
        ((selectedSize == 'papalote') ||
            (selectedProduct?.name == 'Charola eloteco') ||
            (selectedSize == 'esquisopa loca') ||
            (selectedProduct?.name == 'Esquite loco') ||
            (selectedProduct?.name == 'Papa esquite') ||
            (selectedProduct?.name == 'Papas locas'));
  }

  bool _canAddProduct() {
    if (selectedProduct == null) return false;
    if (selectedSize.isEmpty) return false;
    //if (selectedProduct!.sopa != null && selectedSopa == null) return false;
    //     if (_showFrituraSection() && selectedFrituras.isEmpty) return false;
    //     if (_showBolsapapaSection() && selectedBolsapapas == null) return false;
    //     if (selectedProduct!.bebida != null && selectedBebida == null) return false;
    return true;
  }

  void _addProduct() {
    if (_canAddProduct()) {
      widget.onAddProduct(ProductOrder(
        product: selectedProduct!,
        size: selectedSize,
        selectedExtras: List.from(selectedExtras),
        selectedFrituras: List.from(selectedFrituras),
        selectedSopa: selectedSopa,
        selectedBebida: selectedBebida,
        selectedBolsapapas: selectedBolsapapas,
        especificaciones: especificacionesController.text,
        withEverything: withEverything,
      ));

      // Resetear SOLO las selecciones del producto actual
      setState(() {
        // Mantener presionameSelected si ya estaba activado
        // Pero resetear todas las demás selecciones
        selectedProduct = null;
        selectedSize = '';
        selectedExtras.clear();
        selectedFrituras.clear();
        selectedBolsapapas = null;
        selectedSopa = null;
        selectedBebida = null;
        withEverything = false;
        especificacionesController.clear();

        // Si estábamos en modo "Presioname", mantenerlo
        // si no, volver al inicio normal
      });

      // Mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto agregado a la orden'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }}