import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../models/bill.dart';

class PrinterService {

  static Future<void> printReceipt(
    Bill bill,
  ) async {

    String receipt = '';

    receipt += 'SHOP BILL\n';
    receipt += '----------------\n';

    receipt +=
        'Bill No: ${bill.billNo}\n';

    receipt +=
        'Party: ${bill.partyName}\n';

    receipt +=
        'Date: ${bill.date.day}/${bill.date.month}/${bill.date.year}\n';

    receipt +=
        '----------------\n';

    for (var item in bill.items) {

      receipt +=
          '${item.itemName}\n';

      receipt +=
          '${item.qty} x ${item.rate.toStringAsFixed(0)} = ${item.amount.toStringAsFixed(0)}\n';
    }

    receipt +=
        '----------------\n';

    receipt +=
        'Discount: ${bill.discount.toStringAsFixed(0)}\n';

    receipt +=
        'TOTAL: ${bill.grandTotal.toStringAsFixed(0)}\n';

    receipt +=
        '\nThank You\n\n\n';

    await PrintBluetoothThermal.writeBytes(
      receipt.codeUnits,
    );
  }
}