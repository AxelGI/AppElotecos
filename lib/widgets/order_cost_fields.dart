import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';

class OrderCostFields extends StatelessWidget {
  final Order order;
  final Function(void Function()) setParentState;

  const OrderCostFields({
    Key? key,
    required this.order,
    required this.setParentState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de costo extra
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: order.extra?.toStringAsFixed(2) ?? '',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          decoration: const InputDecoration(
            labelText: 'Costo extra',
            prefixText: '\$',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setParentState(() {
                order.extra = 0.0;
                order.updateChange();
              });
              return;
            }

            double? extra = double.tryParse(value);
            if (extra != null) {
              setParentState(() {
                order.extra = extra;
                order.updateChange();
              });
            }
          },
        ),

        const SizedBox(height: 8),

        // Campo de costo envío
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: order.costoEnvio?.toStringAsFixed(2) ?? '',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          decoration: const InputDecoration(
            labelText: 'Costo envío',
            prefixText: '\$',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setParentState(() {
                order.costoEnvio = 0.0;
                order.updateChange();
              });
              return;
            }

            double? envio = double.tryParse(value);
            if (envio != null) {
              setParentState(() {
                order.costoEnvio = envio;
                order.updateChange();
              });
            }
          },
        ),

        const SizedBox(height: 8),

        // Campo de pago cliente
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: order.pagoCliente?.toStringAsFixed(2) ?? '',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          decoration: const InputDecoration(
            labelText: 'Pago cliente',
            prefixText: '\$',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setParentState(() {
                order.pagoCliente = 0.0;
                order.updateChange();
              });
              return;
            }

            double? pago = double.tryParse(value);
            if (pago != null) {
              setParentState(() {
                order.pagoCliente = pago;
                order.updateChange();
              });
            }
          },
        ),

        // Mostrar cambio automáticamente
        if (order.cambioCliente != null && order.cambioCliente != '0.00')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Cambio: \$${order.cambioCliente}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
      ],
    );
  }
}