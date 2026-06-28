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
      child: pw.Text(
        'TAX INVOICE',
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),

    pw.SizedBox(height: 20),

    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('Invoice No : $invoiceNumber'),
        pw.Text(
          'Date : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        ),
      ],
    ),

    pw.Divider(),

    pw.Text(
      'Party : $partyName',
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    ),

    pw.Text('Address : $address'),

    pw.Text('GST No : $gstNo'),

    pw.SizedBox(height: 20),

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

        pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Container(
            width: 220,
            child: pw.Column(
            children: [

            pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
                pw.Text('Taxable Value'),
                pw.Text('₹ ${taxableValue.toStringAsFixed(2)}'),
            ],
            ),

            pw.SizedBox(height: 5),

            pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
                pw.Text('CGST'),
                pw.Text('₹ ${cgstAmount.toStringAsFixed(2)}'),
            ],
            ),

            pw.SizedBox(height: 5),

            pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
                pw.Text('SGST'),
                pw.Text('₹ ${sgstAmount.toStringAsFixed(2)}'),
            ],
            ),

            pw.SizedBox(height: 5),

            pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
                pw.Text('IGST'),
                pw.Text('₹ ${igstAmount.toStringAsFixed(2)}'),
            ],
            ),

            pw.Divider(),

            pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
                pw.Text(
                'Grand Total',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                ),
                ),
                pw.Text(
                '₹ ${grandTotal.toStringAsFixed(2)}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                ),
                ),
            ],
            ),
        ],
        ),
    ),
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