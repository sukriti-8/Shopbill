import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> printInvoice({
  required String partyName,
  required String address,
  required String gstNo,
  required int invoiceNumber,
  required List<Map<String, TextEditingController>> items,
  required double taxableValue,
  required double cgstAmount,
  required double sgstAmount,
  required double igstAmount,
  required double grandTotal,
}) async {
    final pdf=pw.Document();

    final tableData = <List<String>>[];

    for (int i = 0; i < items.length; i++) {
    final row = items[i];

    final qty = double.tryParse(row['qty']!.text) ?? 0;
    final rate = double.tryParse(row['rate']!.text) ?? 0;

    tableData.add([
        '${i + 1}',
        row['item']!.text,
        row['hsn']!.text,
        row['qty']!.text,
        row['rate']!.text,
        (qty * rate).toStringAsFixed(2),
    ]);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: [

    pw.Center(
      child: pw.Column(
        children: [

          pw.Text(
            "GUPTA TOOLS CENTRE",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 3),

          pw.Text(
            "#15-4-562/5, Osman Shahi, Hyderabad - 500012 (TS)",
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),

          pw.Text(
            "GSTIN : 36ACZPA6950D1Z8",
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),

          pw.Text(
            "Cell : 9110760026",
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Text(
            "TAX INVOICE",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    ),

    pw.SizedBox(height: 15),

    pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [

          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text(
                  "Party Details",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Text("Name : $partyName"),

                pw.SizedBox(height: 5),

                pw.Text("Address : $address"),

                pw.SizedBox(height: 5),

                pw.Text("GST No : $gstNo"),
              ],
            ),
          ),

          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text("Invoice No : $invoiceNumber"),

                pw.SizedBox(height: 5),

                pw.Text(
                  "Date : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                ),

                pw.SizedBox(height: 5),

                pw.Text("Transport :"),

                pw.SizedBox(height: 5),

                pw.Text("Bundles :"),
              ],
            ),
          ),
        ],
      ),
    ),

    pw.SizedBox(height: 15),

    pw.SizedBox(height: 20),

    pw.Table.fromTextArray(
        headers: [
            'Sl',
            'Particulars',
            'HSN',
            'Qty',
            'Rate',
            'Taxable',
        ],
        data: tableData,
        border: pw.TableBorder.all(),
        headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
        ),
        headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
        ),
        cellAlignment: pw.Alignment.centerLeft,
        ),
        pw.SizedBox(height: 20),

       // ================= TAX + SUMMARY =================

        pw.Container(
          width: double.infinity,
          height: 120,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
                   ),
          child: pw.Column(
            children: [

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total Taxable Value"),
                  pw.Text("Rs. ${taxableValue.toStringAsFixed(2)}"),
                ],
              ),

              pw.SizedBox(height: 5),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Add : CGST"),
                  pw.Text("Rs. ${cgstAmount.toStringAsFixed(2)}"),
                ],
              ),

              pw.SizedBox(height: 5),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Add : SGST"),
                  pw.Text("Rs. ${sgstAmount.toStringAsFixed(2)}"),
                ],
              ),

              pw.SizedBox(height: 5),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Add : IGST"),
                  pw.Text("Rs. ${igstAmount.toStringAsFixed(2)}"),
                ],
              ),

              pw.Divider(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Total Value After Tax",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "Rs. ${grandTotal.toStringAsFixed(2)}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 15),

        // ================= FOOTER =================

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            pw.Expanded(
              child: pw.Container(
                height: 110,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    pw.Text(
                      "Bank Details",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text("Bank : SBI BANK"),
                    pw.Text("Branch : Gowliguda"),
                    pw.Text("A/C : 10009336302"),
                    pw.Text("IFSC : SBIN0002724"),
                  ],
                ),
              ),
            ),

            pw.SizedBox(width: 6),

            pw.Expanded(
              flex: 2,
              child: pw.Container(
                height: 110,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    pw.Text(
                      "Goods once sold will not be taken or exchanged.",
                    ),

                    pw.SizedBox(height: 8),

                    pw.Text(
                      "SUBJECT TO HYDERABAD JURISDICTION",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 8),

                    pw.Text(
                      "We are not responsible for damage or shortage during transit.",
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(width: 6),

            pw.Expanded(
              child: pw.Container(
                height: 110,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [

                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text(
                        "For GUPTA TOOLS CENTRE",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Text(
                        "Authorised Signatory",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}