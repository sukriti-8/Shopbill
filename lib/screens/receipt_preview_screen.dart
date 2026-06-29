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
                 Builder(
  builder: (context) {

    final settingsBox = Hive.box('settings');

    final shopName = settingsBox.get(
      'shopName',
      defaultValue: 'SHOP BILL',
    );

    final shopAddress = settingsBox.get(
      'shopAddress',
      defaultValue: '',
    );

    final shopPhone = settingsBox.get(
      'shopPhone',
      defaultValue: '',
    );

    return Column(
      children: [

        const Divider(thickness: 2),

        Center(
          child: Text(
            shopName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),

        if (shopAddress.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              shopAddress,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),

        if (shopPhone.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              "Phone : $shopPhone",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),

        const Divider(thickness: 2),

        const SizedBox(height: 10),
      ],
    );
  },
),

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
                        flex: 5,
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

                  ...bill.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item.itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              SizedBox(
                                width: 35,
                                child: Text(
                                  "${item.qty}",
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(
                                width: 45,
                                child: Text(
                                  item.rate.toStringAsFixed(0),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(
                                width: 55,
                                child: Text(
                                  item.amount.toStringAsFixed(0),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(),
                  if (bill.balanceAdjustment != 0)
                    Text(
                      'Balance Adj: ₹${bill.balanceAdjustment.toStringAsFixed(0)}',
                    ),

                  const Divider(),

                  if (bill.balanceAdjustment != 0)
                    Text(
                      'Balance Adj: ₹${bill.balanceAdjustment.toStringAsFixed(0)}',
                    ),

                  const SizedBox(height: 5),

                  Text(
                    'Discount: ${bill.discountPercent.toStringAsFixed(0)}%',
                  ),

                  const SizedBox(height: 5),

                  const Divider(thickness: 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "TOTAL",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "₹${bill.grandTotal.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Divider(thickness: 2),

                  const SizedBox(height: 15),

                  const Center(
                    child: Text(
                      "THANK YOU",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Center(
                    child: Text(
                      "Visit Again",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
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