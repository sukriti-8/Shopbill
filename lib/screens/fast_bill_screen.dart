import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/fast_bill_row.dart';
import '../models/bill.dart';
import '../models/bill_item.dart';

class FastBillScreen extends StatefulWidget {
  const FastBillScreen({super.key});

  @override
  State<FastBillScreen> createState() => _FastBillScreenState();
}

class _FastBillScreenState extends State<FastBillScreen> {
  final partyController = TextEditingController();

  List<FocusNode> itemFocusNodes = [FocusNode()];
  List<FocusNode> qtyFocusNodes = [FocusNode()];
  List<FocusNode> rateFocusNodes = [FocusNode()];

  List<FastBillRow> rows = [
    FastBillRow(),
  ];

  double getGrandTotal() {
    double total = 0;

    for (var row in rows) {
      total += row.amount;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: partyController,
              decoration: const InputDecoration(
                labelText: 'Party Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            const Row(
              children: [
                Expanded(flex: 4, child: Text('Item')),
                Expanded(flex: 2, child: Text('Qty')),
                Expanded(flex: 2, child: Text('Rate')),
                Expanded(flex: 2, child: Text('Amt')),
              ],
            ),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            focusNode: itemFocusNodes[index],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(
                                qtyFocusNodes[index],
                              );
                            },
                            onChanged: (value) {
                              rows[index].itemName = value;
                            },
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: TextField(
                            focusNode: qtyFocusNodes[index],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(
                                rateFocusNodes[index],
                              );
                            },
                            onChanged: (value) {
                              setState(() {
                                rows[index].qty =
                                    int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: TextField(
                            focusNode: rateFocusNodes[index],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                rows[index].rate =
                                    double.tryParse(value) ?? 0;

                                if (
                                    index == rows.length - 1 &&
                                    rows[index].itemName.isNotEmpty) {
                                  rows.add(FastBillRow());

                                  itemFocusNodes.add(FocusNode());
                                  qtyFocusNodes.add(FocusNode());
                                  rateFocusNodes.add(FocusNode());
                                }
                              });
                            },
                            onSubmitted: (_) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  if (index + 1 <
                                      itemFocusNodes.length) {
                                    FocusScope.of(context).requestFocus(
                                      itemFocusNodes[index + 1],
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              rows[index]
                                  .amount
                                  .toStringAsFixed(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            Text(
              'Grand Total: ₹${getGrandTotal()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                List<BillItem> billItems = [];

                for (var row in rows) {
                  if (row.itemName.trim().isNotEmpty) {
                    billItems.add(
                      BillItem(
                        itemName: row.itemName,
                        qty: row.qty,
                        rate: row.rate,
                        amount: row.amount,
                      ),
                    );
                  }
                }

                if (billItems.isEmpty) {
                  return;
                }

                final settingsBox = Hive.box('settings');
                final billsBox = Hive.box('bills');

                int nextBillNo =
                    settingsBox.get(
                      'nextBillNo',
                      defaultValue: 1,
                    );

                final bill = Bill(
                  billNo: nextBillNo,
                  date: DateTime.now(),
                  items: billItems,
                  partyName: partyController.text,
                  discount: 0,
                  grandTotal: getGrandTotal(),
                );

                billsBox.add(bill.toMap());

                settingsBox.put(
                  'nextBillNo',
                  nextBillNo + 1,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bill Saved'),
                  ),
                );
              },
              child: const Text('Save Fast Bill'),
            ),
          ],
        ),
      ),
    );
  }
}