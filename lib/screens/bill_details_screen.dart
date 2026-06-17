import 'package:flutter/material.dart';
import '../models/bill.dart';

class BillDetailsScreen extends StatelessWidget {
  final Bill bill;

  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill #${bill.billNo}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Bill #${bill.billNo}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Date: ${bill.date.day}/${bill.date.month}/${bill.date.year}',
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: bill.items.length,
                itemBuilder: (context, index) {
                  final item = bill.items[index];

                  return ListTile(
                    title: Text(item.itemName),
                    subtitle: Text(
                      'Qty: ${item.qty} | Rate: ${item.rate}',
                    ),
                    trailing: Text(
                      '₹${item.amount}',
                    ),
                  );
                },
              ),
            ),

            Text(
              'Grand Total: ₹${bill.grandTotal}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}