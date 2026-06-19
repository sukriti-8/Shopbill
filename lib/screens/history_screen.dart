import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill.dart';
import 'bill_details_screen.dart';
import '../services/printer_service.dart';

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
  final choice = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Bill Numbering'),
        content: const Text(
          'What do you want to do with bill numbering?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'continue');
            },
            child: const Text('Continue Numbering'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'restart');
            },
            child: const Text('Restart From 1'),
          ),
        ],
      );
    },
  );

  final billsBox = Hive.box('bills');
  final settingsBox = Hive.box('settings');

  await billsBox.clear();

  if (choice == 'restart') {
    await settingsBox.put('nextBillNo', 1);
  }

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

            trailing: IconButton(
              icon: const Icon(Icons.print),
              onPressed: () async {
                await PrinterService.printReceipt(bill);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bill Reprinted'),
                    ),
                  );
                }
              },
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