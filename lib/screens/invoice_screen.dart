import 'package:flutter/material.dart';
import 'invoice_preview_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final partyController = TextEditingController();
  final addressController = TextEditingController();
  final gstController = TextEditingController();
  final transportController = TextEditingController();
  final bundlesController = TextEditingController();

  final cgstController = TextEditingController();
  final sgstController = TextEditingController();
  final igstController = TextEditingController();
  int invoiceNumber = 1;

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
Future<void> saveInvoice() async {
  final prefs = await SharedPreferences.getInstance();

  List<String> history =
      prefs.getStringList('invoice_history') ?? [];

  history.add(
    jsonEncode({
      "party": partyController.text,
      "date":
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "total": getGrandTotal().toStringAsFixed(2),
    }),
  );

  await prefs.setStringList(
    'invoice_history',
    history,
  );
  await prefs.setInt(
  'invoice_number',
  invoiceNumber,
  );
  invoiceNumber++;
}
Future<void> loadInvoiceNumber() async {
  final prefs = await SharedPreferences.getInstance();

  invoiceNumber =
      (prefs.getInt('invoice_number') ?? 0) + 1;

  setState(() {});
}
@override
void initState() {
  super.initState();
  loadInvoiceNumber();
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 3,
                  child: Column(
                    children: [

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Party Details (Sold To)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: partyController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
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
                          labelText: 'GST No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: Column(
                    children: [

                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Invoice No',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          hintText:
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          border: const OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: transportController,
                        decoration: const InputDecoration(
                          labelText: 'Transport',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: bundlesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'No. of Bundles',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Row(
                children: [

                  Expanded(
                    flex: 1,
                    child: Text(
                      'Sl',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

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

                  Expanded(
                    flex: 3,
                    child: Text(
                      'Taxable',
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
                          flex: 1,
                          child: Center(
                            child: Text('${entry.key + 1}'),
                          ),
                        ),

                        const SizedBox(width: 4),

                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          controller: row['item'],
                          focusNode: focusNodes[entry.key]['item'],
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(
                              focusNodes[entry.key]['hsn'],
                            );
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            hintText: 'Item',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          controller: row['hsn'],
                          focusNode: focusNodes[entry.key]['hsn'],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            hintText: 'HSN',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          controller: row['qty'],
                          keyboardType: TextInputType.number,

                          onChanged: (_) {
                            setState(() {});
                          },

                          focusNode: focusNodes[entry.key]['qty'],

                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(
                              focusNodes[entry.key]['rate'],
                            );
                          },

                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            hintText: 'Qty',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          controller: row['rate'],
                          keyboardType: TextInputType.number,
                          focusNode: focusNodes[entry.key]['rate'],

                          onChanged: (_) {
                            setState(() {});
                          },

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

                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            hintText: 'Rate',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          (
                            (double.tryParse(row['qty']!.text) ?? 0) *
                            (double.tryParse(row['rate']!.text) ?? 0)
                          ).toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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

            Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: cgstController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "CGST %",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: sgstController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "SGST %",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: igstController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "IGST %",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
),
            const Divider(thickness: 1.2),

            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 260,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Taxable Value"),
                        Text("₹ ${getTaxableValue().toStringAsFixed(2)}"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("CGST"),
                        Text("${cgstController.text}%"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("SGST"),
                        Text("${sgstController.text}%"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("IGST"),
                        Text("${igstController.text}%"),
                      ],
                    ),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "GRAND TOTAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "₹ ${getGrandTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {

                await saveInvoice();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InvoicePreviewScreen(
                      partyName: partyController.text,
                      address: addressController.text,
                      gstNo: gstController.text,
                      items: items,

                      cgstPercent:
                          double.tryParse(cgstController.text) ?? 0,

                      sgstPercent:
                          double.tryParse(sgstController.text) ?? 0,

                      igstPercent:
                          double.tryParse(igstController.text) ?? 0,
                      invoiceNumber: invoiceNumber,
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