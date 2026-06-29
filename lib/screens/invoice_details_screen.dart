import 'package:flutter/material.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final Map invoice;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invoice #${invoice['invoiceNo']}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              invoice['party'] ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Address : ${invoice['address']}"),

            Text("GST No : ${invoice['gstNo']}"),

            const SizedBox(height: 10),

            Text("Date : ${invoice['date']}"),

            const Divider(height: 30),

            Text(
              "Grand Total",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),

            Text(
              "₹${invoice['total']}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}