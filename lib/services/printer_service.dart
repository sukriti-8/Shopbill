import 'package:hive_flutter/hive_flutter.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../models/bill.dart';

class PrinterService {
  static Future<void> printReceipt(
    Bill bill,
  ) async {

    final settingsBox = Hive.box('settings');

    String? savedMac =
        settingsBox.get('printerMac');

    String shopName =
        settingsBox.get(
      'shopName',
      defaultValue: 'SHOP BILL',
    );

    String shopAddress =
        settingsBox.get(
      'shopAddress',
      defaultValue: '',
    );

    String shopPhone =
        settingsBox.get(
      'shopPhone',
      defaultValue: '',
    );

    bool connected =
        await PrintBluetoothThermal.connectionStatus;

    if (!connected && savedMac != null) {
      await PrintBluetoothThermal.connect(
        macPrinterAddress: savedMac,
      );
    }

    String receipt = '';

    receipt += '      $shopName\n';
    if (shopAddress.isNotEmpty) {
      receipt += '$shopAddress\n';
    }

   if (shopPhone.isNotEmpty) {
    receipt += 'Phone: $shopPhone\n';
    }

    receipt += '\n';

    receipt +=
        '----------------------------\n';

    receipt +=
        'Bill No : ${bill.billNo}\n';

    receipt +=
        'Date    : ${bill.date.day}/${bill.date.month}/${bill.date.year}\n';

    if (bill.partyName.trim().isNotEmpty) {
    receipt +=
        'Party   : ${bill.partyName}\n';
    }

    receipt += '\n';

    receipt +=
        '----------------------------\n';

    receipt +=
        'ITEM'.padRight(16) +
        'QTY'.padLeft(4) +
        'RATE'.padLeft(5) +
        'AMT'.padLeft(5) +
        '\n';
    receipt +=
        '----------------------------\n';

    for (int i = 0; i < bill.items.length; i++) {

  final item = bill.items[i];

  
  String name = item.itemName;

  receipt += "$name\n";

  receipt +=
        "${item.qty.toString().padLeft(18)}"
        "${item.rate.toStringAsFixed(0).padLeft(7)}"
        "${item.amount.toStringAsFixed(0).padLeft(7)}\n\n";
}
    receipt +=
        '----------------------------\n';
    if (bill.balanceAdjustment != 0) {

        receipt +=
            'Balance Adj : ${bill.balanceAdjustment.toStringAsFixed(0)}\n';
        }
    if (bill.discountPercent > 0) {

      double subtotal =
          bill.grandTotal / (1 - (bill.discountPercent / 100));

      receipt +=
          'Subtotal : ${subtotal.toStringAsFixed(0)}\n';

      receipt +=
          'Discount : ${bill.discountPercent.toStringAsFixed(0)}%\n';
    }

    receipt +=
    '============================\n';

    receipt +=
        'TOTAL'.padRight(18) +
        'Rs. ${bill.grandTotal.toStringAsFixed(0)}\n';

    receipt +=
        '============================\n';

    receipt +=
        '----------------------------\n';

    receipt +=
    '\n';

    receipt +=
        '      THANK YOU\n';

    receipt +=
        '     Visit Again\n\n\n';
        await PrintBluetoothThermal.writeBytes(
        receipt.codeUnits,
    );
  }
}