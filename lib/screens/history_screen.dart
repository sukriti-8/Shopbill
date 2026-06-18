import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill.dart';
import 'bill_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  final List<Bill> savedBills;

  const HistoryScreen({
    super.key,
    required this.savedBills,
  });

 @override
State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Bill History'),
  actions: [
    IconButton(
      icon: const Icon(Icons.delete_sweep),
      onPressed: () async {

        final result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Clear History'),
              content: const Text(
                'Delete all bills permanently?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete All'),
                ),
              ],
            );
          },
        );

        if (result == true) {
          final box = Hive.box('bills');

          await box.clear();

          setState(() {
            widget.savedBills.clear();
          });
        }
      },
    ),
  ],
),
      body: ListView.builder(
        itemCount: widget.savedBills.length,
        itemBuilder: (context, index) {
          final bill = widget.savedBills[index];

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
                    savedBills: widget.savedBills,
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