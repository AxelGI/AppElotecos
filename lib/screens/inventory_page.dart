import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order.dart';
import '../models/product_order.dart';


class InventoryPage extends StatefulWidget {
  final List<Order> orders;

  const InventoryPage({Key? key, required this.orders}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  // 🔵 Productos externos (otra marca)
  final List<String> externalProducts = [
    'Banderilla salada',
    'Banderilla dulce',
    'Papas francesa',
  ];

  // Contadores
  Map<String, int> productWithTypeCount = {};
  double totalOrders = 0.0;
  Map<String, int> externalProductWithTypeCount = {};
  double externalOrders = 0.0;
  Map<String, int> frituraCount = {};
  Map<String, int> bolsaPapasCount = {};
  Map<String, int> extrasCount = {};
  Map<String, int> saborMaruchanCount = {};
  Map<String, int> saborBebidasCount = {};

  @override
  void initState() {
    super.initState();
    _calculateInventory();
  }

  void _calculateInventory() {
    // Resetear contadores
    productWithTypeCount.clear();
    externalProductWithTypeCount.clear();
    frituraCount.clear();
    bolsaPapasCount.clear();
    extrasCount.clear();
    saborMaruchanCount.clear();
    saborBebidasCount.clear();
    totalOrders = 0.0;
    externalOrders = 0.0;

    // Procesar las órdenes
    for (var order in widget.orders) {
      for (var po in order.productOrders) {
        String productName = po.product.name;
        String type = po.size;
        String combinedKey = '$productName ($type)';

        int sizeIndex = po.product.sizes.indexOf(po.size);
        num productPrice = sizeIndex != -1 ? po.product.prices[sizeIndex] : 0.0;
        int extrasCost = _calcularCostoExtras(po.selectedExtras, po.cantidad);
        num subtotal = (productPrice + extrasCost) * po.cantidad;

        if (externalProducts.contains(productName)) {
          // 🔵 Productos externos
          externalOrders += subtotal;
          externalProductWithTypeCount[combinedKey] =
              (externalProductWithTypeCount[combinedKey] ?? 0) + po.cantidad;
        } else {
          // 🟢 Productos principales
          totalOrders += subtotal;
          productWithTypeCount[combinedKey] =
              (productWithTypeCount[combinedKey] ?? 0) + po.cantidad;

          // Procesar extras/frituras para productos normales
          _processProductDetails(po);
        }
      }
    }

    setState(() {});
  }

  void _processProductDetails(ProductOrder po) {
    // Frituras
    if (po.selectedFrituras.isNotEmpty) {
      for (var fritura in po.selectedFrituras) {
        frituraCount[fritura] = (frituraCount[fritura] ?? 0) + po.cantidad;
      }
    }

    // Bolsas de papas
    if (po.selectedBolsapapas != null && po.selectedBolsapapas!.isNotEmpty) {
      if (po.selectedBolsapapas!.contains('&')) {
        var bolsaPapasList = po.selectedBolsapapas!.split('&');
        for (var bolsaPapas in bolsaPapasList) {
          bolsaPapasCount[bolsaPapas] =
              (bolsaPapasCount[bolsaPapas] ?? 0) + po.cantidad;
        }
      } else {
        bolsaPapasCount[po.selectedBolsapapas!] =
            (bolsaPapasCount[po.selectedBolsapapas!] ?? 0) + po.cantidad;
      }
    }

    // Sopa Maruchan
    if (po.selectedSopa != null && po.selectedSopa!.isNotEmpty) {
      if (po.selectedSopa!.contains('&')) {
        var saborList = po.selectedSopa!.split('&');
        for (var sabor in saborList) {
          saborMaruchanCount[sabor] = (saborMaruchanCount[sabor] ?? 0) + po.cantidad;
        }
      } else {
        saborMaruchanCount[po.selectedSopa!] =
            (saborMaruchanCount[po.selectedSopa!] ?? 0) + po.cantidad;
      }
    }

    // Bebidas
    if (po.selectedBebida != null && po.selectedBebida!.isNotEmpty) {
      if (po.selectedBebida!.contains('&')) {
        var bebidaList = po.selectedBebida!.split('&');
        for (var bebida in bebidaList) {
          saborBebidasCount[bebida] = (saborBebidasCount[bebida] ?? 0) + po.cantidad;
        }
      } else {
        saborBebidasCount[po.selectedBebida!] =
            (saborBebidasCount[po.selectedBebida!] ?? 0) + po.cantidad;
      }
    }

    // Extras
    for (var extra in po.selectedExtras) {
      extrasCount[extra] = (extrasCount[extra] ?? 0) + po.cantidad;
    }
  }

  int _calcularCostoExtras(List<String> selectedExtras, int cantidad) {
    int costo = 0;
    for (var extra in selectedExtras) {
      if (extra == 'volcano') {
        costo += 10 * cantidad;
      } else if (extra.startsWith('Cobertura')) {
        costo += 10 * cantidad;
      } else if (extra.startsWith('Porcion')) {
        costo += 25 * cantidad;
      } else if (extra.startsWith('Papa')) {
        costo += 20 * cantidad;
      }
    }
    return costo;
  }

  String _generateInventoryMessage() {
    StringBuffer message = StringBuffer();
    message.writeln('📊 *INVENTARIO ELOTECOS* 📊\n');

    message.writeln('🟢 *VENTAS NORMALES:* \$${totalOrders.toStringAsFixed(2)}\n');

    if (productWithTypeCount.isNotEmpty) {
      message.writeln('*Productos principales:*');
      productWithTypeCount.forEach((key, value) {
        message.writeln('• $key: $value');
      });
    }

    if (extrasCount.isNotEmpty) {
      message.writeln('\n*Extras:*');
      extrasCount.forEach((key, value) {
        message.writeln('• $key: $value');
      });
    }

    if (frituraCount.isNotEmpty) {
      message.writeln('\n*Frituras:*');
      frituraCount.forEach((key, value) {
        message.writeln('• $key: $value');
      });
    }

    if (bolsaPapasCount.isNotEmpty) {
      message.writeln('\n*Bolsas de papas:*');
      bolsaPapasCount.forEach((key, value) {
        message.writeln('• $key: $value');
      });
    }

    if (saborMaruchanCount.isNotEmpty) {
      message.writeln('\n*Maruchan:*');
      saborMaruchanCount.forEach((key, value) {
        message.writeln('• $key: $value');
      });
    }

    if (saborBebidasCount.isNotEmpty) {
      message.writeln('\n*Bebidas:*');
      saborBebidasCount.forEach((key, value) {
        message.writeln('• $key: $value');
      });
    }

    if (externalOrders > 0) {
      message.writeln('\n🔵 *VENTAS FRITOLANDIA:* \$${externalOrders.toStringAsFixed(2)}');
      if (externalProductWithTypeCount.isNotEmpty) {
        message.writeln('*Productos externos:*');
        externalProductWithTypeCount.forEach((key, value) {
          message.writeln('• $key: $value');
        });
      }
    }

    message.writeln('\n📅 *Fecha:* ${DateTime.now().toLocal()}');

    return message.toString();
  }

  Future<void> _sendToWhatsApp(String message, String phoneNumber) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir WhatsApp'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: const Color(0xFFFDBC00),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _calculateInventory,
            tooltip: 'Recalcular',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 Ventas normales
              _buildTotalCard(
                title: 'Ventas normales',
                amount: totalOrders,
                color: Colors.green,
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),

              if (productWithTypeCount.isNotEmpty) ...[
                _buildSectionTitle('Productos principales:'),
                _buildProductList(productWithTypeCount),
              ],

              if (extrasCount.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('Extras:'),
                _buildItemList(extrasCount),
              ],

              if (frituraCount.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('Frituras:'),
                _buildItemList(frituraCount),
              ],

              if (bolsaPapasCount.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('Bolsas de papas:'),
                _buildItemList(bolsaPapasCount),
              ],

              if (saborMaruchanCount.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('Maruchan:'),
                _buildItemList(saborMaruchanCount),
              ],

              if (saborBebidasCount.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('Bebidas:'),
                _buildItemList(saborBebidasCount),
              ],

              const SizedBox(height: 30),

              // 🔵 Ventas externas
              if (externalOrders > 0) ...[
                _buildTotalCard(
                  title: 'Ventas Fritolandia',
                  amount: externalOrders,
                  color: Colors.red,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Productos externos:'),
                _buildProductList(externalProductWithTypeCount),
                const SizedBox(height: 30),
              ],

              // Botón de WhatsApp
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    String message = _generateInventoryMessage();
                    _sendToWhatsApp(message, '+5215549683833');
                  },
                  icon: const Icon(Icons.message_rounded, color: Colors.white),
                  label: const Text(
                    'Enviar a WhatsApp',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard({
    required String title,
    required double amount,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        '$title: \$${amount.toStringAsFixed(2)}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildProductList(Map<String, int> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${entry.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemList(Map<String, int> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '• ${entry.key}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                '${entry.value}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}