import 'package:flutter/material.dart';
import '../models/bill.dart';
import 'bill_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<Bill> savedBills;

  const HistoryScreen({
    super.key,
    required this.savedBills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill History'),
      ),
      body: ListView.builder(
        itemCount: savedBills.length,
        itemBuilder: (context, index) {
          final bill = savedBills[index];

          return ListTile(
            title: Text('Bill #${bill.billNo}'),
            subtitle: Text(
             '${bill.partyName}\n₹${bill.grandTotal} | ${bill.status.name}',
            ),
             onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                 builder: (context) => BillDetailsScreen(
                    bill: bill,
                 ),
             ),
         );
       },
      );
        },
      ),
    );
  }
}