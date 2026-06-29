import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final String partyName;
  final String address;
  final String gstNo;
  final List<Map<String, TextEditingController>> items;
  final double cgstPercent;
  final double sgstPercent;
  final double igstPercent;
  final int invoiceNumber;

  const InvoicePreviewScreen({
  super.key,
  required this.partyName,
  required this.address,
  required this.gstNo,
  required this.items,
  required this.cgstPercent,
  required this.sgstPercent,
  required this.igstPercent,
  required this.invoiceNumber,
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
                child: Column(
                  children: [

                    Text(
                      'GUPTA TOOLS CENTRE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    const Text(
                      '#15-4-562/5, Osman Shahi, Hyderabad - 500012 (T.S.)',
                      style: TextStyle(fontSize: 13),
                    ),

                    const Text(
                      'GSTIN : 36ACZPA6950G1Z8',
                      style: TextStyle(fontSize: 13),
                    ),

                    const Text(
                      'Cell : 9110760026',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 15),

                    Text(
                      'TAX INVOICE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Party Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text('Name : $partyName'),

                        SizedBox(height: 4),

                        Text('Address : $address'),

                        SizedBox(height: 4),

                        Text('GST No : $gstNo'),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                         Text('Invoice No : $invoiceNumber'),

                        SizedBox(height: 4),

                        Text(
                          'Date : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        ),

                        SizedBox(height: 4),

                        const Text('Transport :'),

                        SizedBox(height: 4),

                        const Text('Bundles :'),
                      ],
                    ),
                  ),
                ]
              ),

              const SizedBox(height: 20),

              const Divider(),

              Table(
                border: TableBorder.all(
                  color: Colors.black54,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(0.7),
                  1: FlexColumnWidth(3.8),
                  2: FlexColumnWidth(1.4),
                  3: FlexColumnWidth(1.2),
                  4: FlexColumnWidth(1.4),
                  5: FlexColumnWidth(1.8),
                },
                children: const [

                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                    ),
                    children: [

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "Sl",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "PARTICULARS",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "HSN",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "QTY",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "RATE",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "TAXABLE",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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

                return Table(
                  border: TableBorder.all(
                    color: Colors.black54,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.7),
                    1: FlexColumnWidth(3.8),
                    2: FlexColumnWidth(1.4),
                    3: FlexColumnWidth(1.2),
                    4: FlexColumnWidth(1.4),
                    5: FlexColumnWidth(1.8),
                  },
                  children: [
                    TableRow(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            '${items.indexOf(row) + 1}',
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(row['item']!.text),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            row['hsn']!.text,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            row['qty']!.text,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            row['rate']!.text,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            taxable.toStringAsFixed(2),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              const Divider(),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

          
                  Expanded(
                  
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Taxable Value"),
                              Text("₹ ${taxableValue.toStringAsFixed(2)}"),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add : CGST @ $cgstPercent%"),
                              Text("₹ ${cgstAmount.toStringAsFixed(2)}"),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add : SGST @ $sgstPercent%"),
                              Text("₹ ${sgstAmount.toStringAsFixed(2)}"),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add : IGST @ $igstPercent%"),
                              Text("₹ ${igstAmount.toStringAsFixed(2)}"),
                            ],
                          ),

                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Value After Tax",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹ ${grandTotal.toStringAsFixed(2)}",
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
                ],
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Bank Details",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 6),

                            Text("Bank : SBI BANK"),
                            Text("Branch : Gowliguda"),
                            Text("A/C : 10009336302"),
                            Text("IFSC : SBIN0002724"),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 120,
                      color: Colors.black38,
                    ),

                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Goods once sold will not be taken or exchanged.",
                            ),

                            SizedBox(height: 6),

                            Text(
                              "SUBJECT TO HYDERABAD JURISDICTION",
                            ),

                            SizedBox(height: 6),

                            Text(
                              "We are not responsible for damage or shortage during transit.",
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 120,
                      color: Colors.black38,
                    ),

                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SizedBox(height: 10),

                          Text(
                            "For GUPTA TOOLS CENTRE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 55),

                          Text("Authorised Signatory"),

                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await PdfService.printInvoice(
                      partyName: partyName,
                      address: address,
                      gstNo: gstNo,
                      invoiceNumber: invoiceNumber,
                      items: items,
                      taxableValue: taxableValue,
                      cgstAmount: cgstAmount,
                      sgstAmount: sgstAmount,
                      igstAmount: igstAmount,
                      grandTotal: grandTotal,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Generate PDF"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}