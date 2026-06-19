import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:hive_flutter/hive_flutter.dart';
class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() =>
      _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState
    extends State<PrinterSettingsScreen> {

  List<BluetoothInfo> devices = [];
  String connectedMac = '';

  Future<void> loadPairedDevices() async {
    final list =
        await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
      devices = list;
    });
  }
  Future<void> connectPrinter(String mac) async {

    bool success =
        await PrintBluetoothThermal.connect(
        macPrinterAddress: mac,
    );

    if (success) {

        final settingsBox = Hive.box('settings');

        settingsBox.put(
        'printerMac',
        mac,
        );

        setState(() {
        connectedMac = mac;
        });

        if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
            content: Text('Printer Connected'),
            ),
        );
        }
    }
    }

    Future<void> autoConnectPrinter() async {

    final settingsBox = Hive.box('settings');

    String? savedMac =
        settingsBox.get('printerMac');

    if (savedMac == null) {
        return;
    }

    bool success =
        await PrintBluetoothThermal.connect(
        macPrinterAddress: savedMac,
    );

    if (success) {
        setState(() {
        connectedMac = savedMac;
        });
    }
    }

Future<void> testPrint() async {

  List<int> bytes = [];

  bytes.addAll(
    'HELLO SHOPBILL\n\n\n'.codeUnits,
  );

  await PrintBluetoothThermal.writeBytes(
    bytes,
  );
}

  @override
    void initState() {
    super.initState();

    loadPairedDevices();

    Future.delayed(
        const Duration(seconds: 1),
        () {
        autoConnectPrinter();
        },
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Settings'),
      ),
      body: Column(
        children: [

          ElevatedButton(
            onPressed: loadPairedDevices,
            child: const Text('Refresh'),
          ),
          ElevatedButton(
            onPressed: testPrint,
            child: const Text('Print Test'),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {

                final device = devices[index];

            return ListTile(
  title: Text(device.name),
  subtitle: Text(device.macAdress),

  trailing: ElevatedButton(
    onPressed: () {
      connectPrinter(device.macAdress);
    },
    child: Text(
      connectedMac == device.macAdress
          ? 'Connected'
          : 'Connect',
    ),
  ),
);
              },
            ),
          ),
        ],
      ),
    );
  }
}