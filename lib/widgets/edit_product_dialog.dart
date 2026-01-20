// widgets/edit_product_dialog.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_order.dart';

class EditProductDialog extends StatefulWidget {
  final ProductOrder productOrder;
  final Function(ProductOrder) onSave;
  final Function() onDelete;

  const EditProductDialog({
    Key? key,
    required this.productOrder,
    required this.onSave,
    required this.onDelete,
  }) : super(key: key);

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late ProductOrder _editedProductOrder;
  late String _selectedSize;
  late List<String> _selectedExtras;
  late List<String> _selectedFrituras;
  late String? _selectedSopa;
  late String? _selectedBebida;
  late String? _selectedBolsapapas;
  late bool _withEverything;
  late TextEditingController _especificacionesController;

  @override
  void initState() {
    super.initState();
    _editedProductOrder = widget.productOrder;
    _selectedSize = widget.productOrder.size;
    _selectedExtras = List.from(widget.productOrder.selectedExtras);
    _selectedFrituras = List.from(widget.productOrder.selectedFrituras);
    _selectedSopa = widget.productOrder.selectedSopa;
    _selectedBebida = widget.productOrder.selectedBebida;
    _selectedBolsapapas = widget.productOrder.selectedBolsapapas;
    _withEverything = widget.productOrder.withEverything;
    _especificacionesController = TextEditingController(
        text: widget.productOrder.especificaciones ?? ''
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar ${widget.productOrder.product.name}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cantidad
            _buildCantidadField(),

            // Tamaño
            if (_editedProductOrder.product.sizes.isNotEmpty)
              _buildSizeSelection(),

            // Sopa
            if (_editedProductOrder.product.sopa != null)
              _buildSopaSelection(),

            // Bebida
            if (_editedProductOrder.product.bebida != null)
              _buildBebidaSelection(),

            // Fritura
            if (_showFrituraSection())
              _buildFrituraSelection(),

            // Bolsa de papas
            if (_showBolsapapaSection())
              _buildBolsapapaSelection(),

            // Con todo
            _buildConTodoCheckbox(),

            // Especificaciones
            if (!_withEverything)
              _buildEspecificaciones(),

            // Extras
            if (_editedProductOrder.product.extras.isNotEmpty)
              _buildExtrasSelection(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onDelete,
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _buildCantidadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cantidad:', style: TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (_editedProductOrder.cantidad > 1) {
                  setState(() {
                    _editedProductOrder.cantidad--;
                  });
                }
              },
            ),
            Text(
              '${_editedProductOrder.cantidad}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _editedProductOrder.cantidad++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Tipo:', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: _editedProductOrder.product.sizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: _selectedSize == size,
              onSelected: (selected) {
                setState(() {
                  _selectedSize = size;
                  _selectedSopa = null;
                  _selectedFrituras.clear();
                  _selectedBolsapapas = null;
                });
              },
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
        const Text('Sopa:', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: _editedProductOrder.product.sopa!.map((sopa) {
            return ChoiceChip(
              label: Text(sopa),
              selected: _selectedSopa == sopa,
              onSelected: (selected) {
                setState(() {
                  _selectedSopa = sopa;
                });
              },
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
        const Text('Bebida:', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: _editedProductOrder.product.bebida!.map((bebida) {
            return ChoiceChip(
              label: Text(bebida),
              selected: _selectedBebida == bebida,
              onSelected: (selected) {
                setState(() {
                  _selectedBebida = bebida;
                });
              },
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
        const Text('Fritura:', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: _editedProductOrder.product.fritura!.map((fritura) {
            return FilterChip(
              label: Text(fritura),
              selected: _selectedFrituras.contains(fritura),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFrituras.add(fritura);
                  } else {
                    _selectedFrituras.remove(fritura);
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
        const Text('Bolsa de papas:', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: _editedProductOrder.product.bolsapapa!.map((bolsapapa) {
            return ChoiceChip(
              label: Text(bolsapapa),
              selected: _selectedBolsapapas == bolsapapa,
              onSelected: (selected) {
                setState(() {
                  _selectedBolsapapas = bolsapapa;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConTodoCheckbox() {
    return CheckboxListTile(
      title: const Text('Con todo'),
      value: _withEverything,
      onChanged: (value) {
        setState(() {
          _withEverything = value ?? false;
          if (_withEverything) {
            _especificacionesController.clear();
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
          controller: _especificacionesController,
          decoration: const InputDecoration(
            labelText: 'Especificaciones',
            border: OutlineInputBorder(),
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
        const Text('Extras:', style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: _editedProductOrder.product.extras.map((extra) {
            return FilterChip(
              label: Text(extra),
              selected: _selectedExtras.contains(extra),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedExtras.add(extra);
                  } else {
                    _selectedExtras.remove(extra);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _showFrituraSection() {
    return _editedProductOrder.product.fritura != null &&
        ((_selectedSize == 'papalote') ||
            (_selectedSize == 'loco') ||
            (_selectedSize == 'fritura') ||
            (_selectedSize == 'esquite y fritura') ||
            (_selectedSize == 'esquisopa loca') ||
            (_editedProductOrder.product.name == 'Esquite loco') ||
            (_editedProductOrder.product.name == 'Papa esquite') ||
            (_editedProductOrder.product.name == 'Banderilla salada') ||
            (_editedProductOrder.product.name == 'Arizona loco') ||
            (_editedProductOrder.product.name == 'Costillitas'));
  }

  bool _showBolsapapaSection() {
    return _editedProductOrder.product.bolsapapa != null &&
        ((_selectedSize == 'papalote') ||
            (_editedProductOrder.product.name == 'Charola eloteco') ||
            (_selectedSize == 'esquisopa loca') ||
            (_editedProductOrder.product.name == 'Esquite loco') ||
            (_editedProductOrder.product.name == 'Papa esquite') ||
            (_editedProductOrder.product.name == 'Papas locas'));
  }

  void _saveChanges() {
    final updatedProductOrder = ProductOrder(
      product: _editedProductOrder.product,
      size: _selectedSize,
      cantidad: _editedProductOrder.cantidad,
      selectedExtras: List.from(_selectedExtras),
      selectedFrituras: List.from(_selectedFrituras),
      selectedSopa: _selectedSopa,
      selectedBebida: _selectedBebida,
      selectedBolsapapas: _selectedBolsapapas,
      especificaciones: _especificacionesController.text.isNotEmpty
          ? _especificacionesController.text
          : null,
      withEverything: _withEverything,
    );

    widget.onSave(updatedProductOrder);
    Navigator.pop(context);
  }
}