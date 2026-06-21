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

    receipt += '$shopName\n';

    if (shopAddress.isNotEmpty) {
      receipt += '$shopAddress\n';
    }

    if (shopPhone.isNotEmpty) {
      receipt += 'Phone: $shopPhone\n';
    }

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

    receipt +=
        '----------------------------\n';

    receipt +=
        'Item         Qty Rate   Amt\n';

    receipt +=
        '----------------------------\n';

    for (var item in bill.items) {

      String name =
          item.itemName.length > 12
              ? item.itemName.substring(0, 12)
              : item.itemName.padRight(12);

      String qty =
          item.qty.toString().padLeft(4);

      String rate =
          item.rate.toStringAsFixed(0).padLeft(6);

      String amount =
          item.amount.toStringAsFixed(0).padLeft(6);

      receipt +=
          '$name$qty$rate$amount\n';
    }

    receipt +=
        '----------------------------\n';

    if (bill.discountPercent > 0) {

      double subtotal =
          bill.grandTotal / (1 - (bill.discountPercent / 100));

      receipt +=
          'Subtotal : ${subtotal.toStringAsFixed(0)}\n';

      receipt +=
          'Discount : ${bill.discountPercent.toStringAsFixed(0)}%\n';
    }

    receipt +=
        'TOTAL'.padRight(24) +
        bill.grandTotal.toStringAsFixed(0) +
        '\n';

    receipt +=
        '----------------------------\n';

    receipt +=
        '\nThank You\n\n\n';

    await PrintBluetoothThermal.writeBytes(
      receipt.codeUnits,
    );
  }
}