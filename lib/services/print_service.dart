import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
//import  as img;
import 'package:image/image.dart' as img;
import '../models/order.dart';
import '../models/product_order.dart';

class PrintService {
  static Future<void> printOrder(Order order) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      try {
        List<int> ticket = await _generateOrderTicket(order);
        final result = await PrintBluetoothThermal.writeBytes(ticket);
        print("Print result: $result");
      } catch (e) {
        print("Error al imprimir: $e");
      }
    } else {
      print("Bluetooth no está conectado.");
    }
  }

  static Future<List<int>> _generateOrderTicket(Order order) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final ByteData data = await rootBundle.load('images/Logo_Elotecos.PNG');
    final Uint8List bytesImg = data.buffer.asUint8List();
    final decodedImage = img.decodeImage(Uint8List.fromList(bytesImg))!;
    final resizedImage = img.copyResize(decodedImage, width: 250, height: 250);

    bytes += generator.image(resizedImage);
    bytes += generator.text('55 4968 3833', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Orden #${order.index}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Para ${order.place}', styles: const PosStyles(align: PosAlign.center));

    for (var productOrder in order.productOrders) {
      bytes += _generateProductSection(generator, productOrder);
    }

    bytes += generator.text('');

    if (order.extra != null && order.extra! > 0) {
      bytes += generator.text('Extra: \$${order.extra}', styles: const PosStyles(align: PosAlign.left));
    }

    if (order.costoEnvio != null && order.costoEnvio! > 0) {
      bytes += generator.text('Costo repartidor: \$${order.costoEnvio}', styles: const PosStyles(align: PosAlign.left));
    }

    bytes += generator.text(
        'Total: \$${order.total}',
        styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size3)
    );

    bytes += generator.text('');
    bytes += generator.qrcode('https://www.instagram.com/elotecos_las_americas', size: const QRSize(100));
    bytes += generator.feed(2);

    return bytes;
  }

  static List<int> _generateProductSection(Generator generator, ProductOrder productOrder) {
    List<int> bytes = [];

    bytes += generator.row([
      PosColumn(
        text: 'x${productOrder.cantidad} ${productOrder.product.name}',
        width: 8,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: '\$${productOrder.totalPrice}',
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    if (productOrder.size.isNotEmpty && productOrder.size != "-") {
      bytes += generator.text('  ${productOrder.size}', styles: const PosStyles(align: PosAlign.left));
    }

    if (productOrder.selectedFrituras.isNotEmpty) {
      bytes += generator.text('  Fritura: ${productOrder.selectedFrituras.join("&")}', styles: const PosStyles(align: PosAlign.left));
    }

    if (productOrder.selectedSopa != null && productOrder.selectedSopa!.isNotEmpty) {
      bytes += generator.text('  Sopa: ${productOrder.selectedSopa}', styles: const PosStyles(align: PosAlign.left));
    }

    if (productOrder.selectedBebida != null && productOrder.selectedBebida!.isNotEmpty) {
      bytes += generator.text('  Bebida: ${productOrder.selectedBebida}', styles: const PosStyles(align: PosAlign.left));
    }

    if (productOrder.selectedBolsapapas != null && productOrder.selectedBolsapapas!.isNotEmpty) {
      bytes += generator.text('  Bolsa papas: ${productOrder.selectedBolsapapas}', styles: const PosStyles(align: PosAlign.left));
    }

    if (productOrder.withEverything) {
      bytes += generator.text('  Con todo', styles: const PosStyles(align: PosAlign.left));
    }

    if (productOrder.especificaciones != null && productOrder.especificaciones!.isNotEmpty) {
      bytes += generator.text('***Detalles: ${productOrder.especificaciones}****', styles: const PosStyles(align: PosAlign.left, bold: true));
    }

    for (String extra in productOrder.selectedExtras) {
      int extraCost = 0;
      if (extra == 'volcano' || extra.startsWith('Cobertura')) {
        extraCost = 10 * productOrder.cantidad;
      } else if (extra.startsWith('Porcion')) {
        extraCost = 25 * productOrder.cantidad;
      } else if (extra.startsWith('Papa')) {
        extraCost = 20 * productOrder.cantidad;
      }

      if (extraCost > 0) {
        bytes += generator.row([
          PosColumn(
            text: 'x${productOrder.cantidad} $extra',
            width: 8,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: '\$$extraCost*${productOrder.cantidad}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    return bytes;
  }
}