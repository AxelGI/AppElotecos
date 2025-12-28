import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothPrintPage extends StatefulWidget {
  @override
  _BluetoothPrintPageState createState() => _BluetoothPrintPageState();
}

class _BluetoothPrintPageState extends State<BluetoothPrintPage> {
  bool _isBluetoothEnabled = false;
  String _connectedDeviceName = "";
  List<BluetoothInfo> _foundDevices = [];

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
  }

  Future<void> _checkBluetoothStatus() async {
    bool isEnabled = await PrintBluetoothThermal.bluetoothEnabled;
    setState(() {
      _isBluetoothEnabled = isEnabled;
    });
  }

  Future<void> _enableBluetooth() async {
    try {
      FlutterBlue flutterBlue = FlutterBlue.instance;
      bool isBluetoothEnabled = await flutterBlue.isOn;

      if (!isBluetoothEnabled) {
        print('Bluetooth no está habilitado');
        return;
      }

      setState(() {
        _isBluetoothEnabled = true;
      });
    } catch (e) {
      print('Error habilitando Bluetooth: $e');
    }
  }

  Future<void> _scanBluetoothDevices() async {
    try {
      if (await PrintBluetoothThermal.isPermissionBluetoothGranted) {
        bool isBluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;

        if (isBluetoothEnabled) {
          final List<BluetoothInfo> foundDevices =
          await PrintBluetoothThermal.pairedBluetooths;

          setState(() {
            _foundDevices = foundDevices;
            _isBluetoothEnabled = isBluetoothEnabled;
          });

          print('Dispositivos Bluetooth escaneados: $_foundDevices');
        } else {
          print('Bluetooth no está habilitado.');
        }
      } else {
        print('Permiso de Bluetooth no otorgado.');
      }
    } catch (e) {
      print('Error escaneando dispositivos Bluetooth: $e');
    }
  }

  Future<void> _connectToDevice(BluetoothInfo device) async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress);

      if (isConnected) {
        setState(() {
          _connectedDeviceName = device.name;
        });
        _showSnackBar('Conectado a ${device.name}');
      } else {
        _showSnackBar('Error al conectar con la impresora');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _disconnectFromDevice() async {
    try {
      await PrintBluetoothThermal.disconnect;
      setState(() {
        _connectedDeviceName = "";
      });
      _showSnackBar('Desconectado de la impresora');
    } catch (e) {
      _showSnackBar('Error al desconectar: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impresora Bluetooth'),
        backgroundColor: const Color(0xFFFDBC00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Estado del Bluetooth
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _isBluetoothEnabled ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    _isBluetoothEnabled
                        ? 'Bluetooth Habilitado'
                        : 'Bluetooth Deshabilitado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Dispositivo conectado
            if (_connectedDeviceName.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bluetooth_connected,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Conectado: $_connectedDeviceName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _enableBluetooth();
                    await _scanBluetoothDevices();
                  },
                  child: const Text('Buscar dispositivos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isBluetoothEnabled) {
                      _disconnectFromDevice();
                    } else {
                      _enableBluetooth();
                    }
                  },
                  child: Text(
                    _isBluetoothEnabled ? 'Desconectar' : 'Habilitar',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Lista de dispositivos
            Expanded(
              child: _foundDevices.isEmpty
                  ? const Center(
                child: Text(
                  'No se encontraron dispositivos',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _foundDevices.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.print),
                      title: Text(_foundDevices[index].name),
                      subtitle: Text(_foundDevices[index].macAdress),
                      trailing: _connectedDeviceName == _foundDevices[index].name
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : ElevatedButton(
                        onPressed: () => _connectToDevice(_foundDevices[index]),
                        child: const Text('Conectar'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}