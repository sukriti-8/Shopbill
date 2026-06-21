import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill.dart';
import '../services/printer_service.dart';

class ReceiptPreviewScreen extends StatelessWidget {
  final Bill bill;

  const ReceiptPreviewScreen({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'SHOP BILL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text('Bill No: ${bill.billNo}'),

                  Text(
                    'Date: ${bill.date.day}/${bill.date.month}/${bill.date.year}',
                  ),

                  const SizedBox(height: 10),

                  Text('Party: ${bill.partyName}'),

                  const Divider(),
                  const Row(
                    children: [

                      Expanded(
                        flex: 4,
                        child: Text(
                          'Item',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          'Amt',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(),

                  ...bill.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(item.itemName),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('${item.qty}'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.rate.toStringAsFixed(0),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.amount.toStringAsFixed(0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),

                  Text(
                    'Discount: ₹${bill.discountPercent.toStringAsFixed(0)}%',
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'TOTAL: ₹${bill.grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text('Thank You'),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Edit'),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {

                          final billsBox = Hive.box('bills');
                          final settingsBox = Hive.box('settings');

                          billsBox.add(bill.toMap());

                          settingsBox.put(
                            'nextBillNo',
                            bill.billNo + 1,
                          );

                          await PrinterService.printReceipt(
                            bill,
                          );

                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                          child: const Text('Save & Print'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}