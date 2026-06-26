import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'receipt_preview_screen.dart';

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
  final discountController = TextEditingController();
  final balanceController = TextEditingController();

  bool showBalance = false;
  double balanceAdjustment = 0;


bool showDiscount = false;
double discountPercent = 0;

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
  double getFinalTotal() {

      double subtotal =
          getGrandTotal() + balanceAdjustment;

      double discountAmount =
          subtotal * (discountPercent / 100);

      return subtotal - discountAmount;
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
                Expanded(
                  flex: 5,
                  child: Text(
                    'Item',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Amt',
                    textAlign: TextAlign.center,
                  ),
                ),
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
                          flex: 5,
                          child: SizedBox(
                            height: 42,
                            child: TextField(
                              focusNode: itemFocusNodes[index],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
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
                        ),

                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 42,
                            child: TextField(
                              focusNode: qtyFocusNodes[index],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                              ),
                              onSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                  rateFocusNodes[index],
                                );
                              },
                              onChanged: (value) {
                                setState(() {
                                  rows[index].qty = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 42,
                            child: TextField(
                              focusNode: rateFocusNodes[index],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                              ),
                              onSubmitted: (_) {
                                if (index == rows.length - 1) {
                                  setState(() {
                                   rows.add(
                                    FastBillRow(
                                      itemName: '',
                                      qty: 0,
                                      rate: 0,
                                    ),
                                  );

                                    itemFocusNodes.add(FocusNode());
                                    qtyFocusNodes.add(FocusNode());
                                    rateFocusNodes.add(FocusNode());
                                  });

                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      FocusScope.of(context).requestFocus(
                                        itemFocusNodes.last,
                                      );
                                    },
                                  );
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  rows[index].rate = double.tryParse(value) ?? 0;
                                });
                              },
                            ),
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

            Column(
              children: [
                Text(
                  'Items Total: ₹${getGrandTotal().toStringAsFixed(0)}',
                ),

                Text(
                  'Balance Adj: ₹${balanceAdjustment.toStringAsFixed(0)}',
                ),

                Text(
                  'Final Total: ₹${getFinalTotal().toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!showBalance)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showBalance = true;
                    });
                  },
                  child: const Text('+ Add Balance Adjustment'),
                ),

              if (showBalance) ...[
                TextField(
                  controller: balanceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Balance Adjustment (+/-)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      balanceAdjustment =
                          double.tryParse(value) ?? 0;
                    });
                  },
                ),

                const SizedBox(height: 10),

                Text(
                  'Balance Adjustment: ₹$balanceAdjustment',
                ),

                const SizedBox(height: 10),
              ],
            if (!showDiscount)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showDiscount = true;
                  });
                },
                child: const Text('+ Add Discount'),
              ),

            if (showDiscount) ...[
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Discount %',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    discountPercent = double.tryParse(value) ?? 0;
                  });
                },
              ),

              const SizedBox(height: 10),

              Text(
                'Discount: ₹$discountPercent',
              ),
            ],
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: ()  async {
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
                  discountPercent: discountPercent,
                  balanceAdjustment: balanceAdjustment,
                  grandTotal: getFinalTotal(),
                );

                

                

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReceiptPreviewScreen(
                      bill: bill,
                    ),
                  ),
                );

                if (result == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FastBillScreen(),
                    ),
                  );
                }

                
              },
              child: const Text('Preview Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}