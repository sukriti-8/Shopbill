import 'package:flutter/material.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final String partyName;
  final String address;
  final String gstNo;
  final List<Map<String, TextEditingController>> items;
  final double cgstPercent;
 final double sgstPercent;
 final double igstPercent;

  const InvoicePreviewScreen({
  super.key,
  required this.partyName,
  required this.address,
  required this.gstNo,
  required this.items,
  required this.cgstPercent,
  required this.sgstPercent,
  required this.igstPercent,
});

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

  @override
  Widget build(BuildContext context) {

    double taxableValue = getTaxableValue();
    print('CGST = $cgstPercent');
    print('SGST = $sgstPercent');
    print('IGST = $igstPercent');

    
    double cgstAmount =
        taxableValue * (cgstPercent / 100);

    double sgstAmount =
        taxableValue * (sgstPercent / 100);

    double igstAmount =
        taxableValue * (igstPercent / 100);

    double grandTotal =
        taxableValue +
        cgstAmount +
        sgstAmount +
        igstAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Center(
                child: Text(
                  'INVOICE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Invoice No: 1',
              ),

              Text(
                'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              ),

              const SizedBox(height: 20),

              Text(
                'Party Name: $partyName',
              ),

              Text(
                'Address: $address',
              ),

              Text(
                'GST No: $gstNo',
              ),

              const SizedBox(height: 20),

              const Divider(),

              const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Particulars',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'HSN',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Qty',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Rate',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Taxable',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(),

              ...items.map((row) {

                final qty =
                    double.tryParse(
                      row['qty']!.text,
                    ) ??
                    0;

                final rate =
                    double.tryParse(
                      row['rate']!.text,
                    ) ??
                    0;

                final taxable =
                    qty * rate;

                return Row(
                  children: [

                    Expanded(
                      flex: 4,
                      child: Text(
                        row['item']!.text,
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        row['hsn']!.text,
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        row['qty']!.text,
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        row['rate']!.text,
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: Text(
                        taxable
                            .toStringAsFixed(2),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              const Divider(),

              Text(
                'Taxable Value : ₹${taxableValue.toStringAsFixed(2)}',
              ),

              Text(
                'CGST : ₹${cgstAmount.toStringAsFixed(2)}',
              ),

              Text(
                'SGST : ₹${sgstAmount.toStringAsFixed(2)}',
              ),

              Text(
                'IGST : ₹${igstAmount.toStringAsFixed(2)}',
              ),

              const SizedBox(height: 10),

              Text(
                'Grand Total : ₹${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}