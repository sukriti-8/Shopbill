import 'package:flutter/material.dart';
import 'invoice_preview_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final partyController = TextEditingController();
  final addressController = TextEditingController();
  final gstController = TextEditingController();

  final cgstController = TextEditingController();
  final sgstController = TextEditingController();
  final igstController = TextEditingController();

  List<Map<String, TextEditingController>> items = [
    {
      'item': TextEditingController(),
      'hsn': TextEditingController(),
      'qty': TextEditingController(),
      'rate': TextEditingController(),
    },
  ];
  List<Map<String, FocusNode>> focusNodes = [
  {
    'item': FocusNode(),
    'hsn': FocusNode(),
    'qty': FocusNode(),
    'rate': FocusNode(),
  },
];
double getTaxableValue() {
  double total = 0;

  for (var row in items) {
    final qty =
        double.tryParse(row['qty']!.text) ?? 0;

    final rate =
        double.tryParse(row['rate']!.text) ?? 0;

    total += qty * rate;
  }

  return total;
}

double getGrandTotal() {
  double taxable = getTaxableValue();

  double cgst =
      taxable *
      ((double.tryParse(cgstController.text) ?? 0) / 100);

  double sgst =
      taxable *
      ((double.tryParse(sgstController.text) ?? 0) / 100);

  double igst =
      taxable *
      ((double.tryParse(igstController.text) ?? 0) / 100);

  return taxable + cgst + sgst + igst;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: SingleChildScrollView(
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

            const SizedBox(height: 10),

            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: gstController,
              decoration: const InputDecoration(
                labelText: 'GST Number',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: cgstController,
              onChanged: (_) {
                setState(() {});
                },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CGST %',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sgstController,
              onChanged: (_) {
                setState(() {});
                },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'SGST %',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: igstController,
              onChanged: (_) {
                setState(() {});
                },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'IGST %',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'Particulars',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'HSN',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Qty',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Divider(),

            ...items.asMap().entries.map((entry) {
              final row = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: row['item'],
                        focusNode: focusNodes[entry.key]['item'],
                        onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            focusNodes[entry.key]['hsn'],
                        );
},
                        decoration: const InputDecoration(
                          isDense: true,
                           contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                        ),
                          hintText: 'Item',
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: row['hsn'],
                        focusNode: focusNodes[entry.key]['hsn'],
                        onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            focusNodes[entry.key]['qty'],
                        );
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                           contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                            ),
                          hintText: 'HSN',
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: row['qty'],
                        onChanged: (_) {
                            setState(() {});
                            },
                        focusNode: focusNodes[entry.key]['qty'],
                        onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            focusNodes[entry.key]['rate'],
                        );
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                           contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                        ),
                          hintText: 'Qty',
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: row['rate'],
                        onChanged: (_) {
                            setState(() {});
                            },
                        focusNode: focusNodes[entry.key]['rate'],
                        onSubmitted: (_) {

                        if (entry.key == items.length - 1) {

                            setState(() {
                            items.add({
                                'item': TextEditingController(),
                                'hsn': TextEditingController(),
                                'qty': TextEditingController(),
                                'rate': TextEditingController(),
                            });

                            focusNodes.add({
                                'item': FocusNode(),
                                'hsn': FocusNode(),
                                'qty': FocusNode(),
                                'rate': FocusNode(),
                            });
                            });

                            Future.delayed(
                            const Duration(milliseconds: 100),
                            () {
                                FocusScope.of(context).requestFocus(
                                focusNodes.last['item'],
                                );
                            },
                            );
                        }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                           contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                            ),
                          hintText: 'Rate',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  items.add({
                    'item': TextEditingController(),
                    'hsn': TextEditingController(),
                    'qty': TextEditingController(),
                    'rate': TextEditingController(),
                  });
                  focusNodes.add({
                    'item': FocusNode(),
                    'hsn': FocusNode(),
                    'qty': FocusNode(),
                    'rate': FocusNode(),
                    });

                });
              },
              child: const Text('Add Row'),
            ),
            const SizedBox(height: 20),

            Text(
            'Taxable Value : ₹${getTaxableValue().toStringAsFixed(2)}',
            ),

            const SizedBox(height: 5),

            Text(
            'Grand Total : ₹${getGrandTotal().toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
            ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InvoicePreviewScreen(
                                        partyName: partyController.text,
                                        address: addressController.text,
                                        gstNo: gstController.text,
                                        items: items,

                                        cgstPercent:
                                            double.tryParse(
                                                cgstController.text,
                                            ) ??
                                            0,

                                        sgstPercent:
                                            double.tryParse(
                                                sgstController.text,
                                            ) ??
                                            0,

                                        igstPercent:
                                            double.tryParse(
                                                igstController.text,
                                            ) ??
                                            0,
                                        ),
                  ),
                );
              },
              child: const Text('Preview Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}