import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill.dart';

class BillDetailsScreen extends StatefulWidget {
  final Bill bill;
  final List<Bill> savedBills;

  const BillDetailsScreen({
    super.key,
    required this.bill,
    required this.savedBills,
  });

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill #${widget.bill.billNo}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () async {

            if (widget.bill.status == BillStatus.active) {

                final result = await showDialog(
                    context: context,
                    builder: (context) {
                        return AlertDialog(
                            title: const Text('Cancel Bill'),
                            content: const Text(
                                'Are you sure you want to cancel this bill?',
                             ),
                            actions: [
                              IconButton(
                                 icon: const Icon(Icons.cancel),
                                onPressed: () async {
                                   
                                },
                              ),

                              IconButton(
                                 icon: const Icon(Icons.delete),
                                 onPressed: () async {

                                  final result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Bill'),
                                      content: const Text(
                                         'Are you sure you want to permanently delete this bill?',
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
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (result == true) {

                                      final box = Hive.box('bills');

                                      final hiveIndex = widget.savedBills.indexOf(widget.bill);

                                      if (hiveIndex >= 0) {
                                        box.deleteAt(hiveIndex);
                                        widget.savedBills.removeAt(hiveIndex);
                                      }

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                        );
                    },
                );

                if (result == true) {
                    setState(() {
                        widget.bill.status = BillStatus.cancelled;
                    });
                 }

                } else {

                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                            return AlertDialog(
                                title: const Text('Restore Bill'),
                                content: const Text(
                                    'Do you want to make this bill active again?',
                                ),
                                actions: [
                                    TextButton(
                                        onPressed: () {
                                            Navigator.pop(context, false);
                                        },
                                        child: const Text('Keep Cancelled'),
                                    ),
                                    TextButton(   
                                       onPressed: () {
                                            Navigator.pop(context, true);
                                        },      
                                        child: const Text('Make Active'),
                                    ),
                                ],
                            );
                        },
                   );

                    if (result == true) {
                        setState(() {
                                widget.bill.status = BillStatus.active;
                            });
                        }
                    }
                },
            ),  
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill #${widget.bill.billNo}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
           

            Text(
                'Party: ${widget.bill.partyName}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

            Text(
              'Date: ${widget.bill.date.day}/${widget.bill.date.month}/${widget.bill.date.year}',
            ),

            const SizedBox(height: 10),

            Text(
              'Status: ${widget.bill.status.name}',
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: widget.bill.items.length,
                itemBuilder: (context, index) {
                  final item = widget.bill.items[index];

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
              'Subtotal: ₹${widget.bill.grandTotal / (1 - (widget.bill.discountPercent / 100))}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Discount: ${widget.bill.discountPercent}%',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Grand Total: ₹${widget.bill.grandTotal}',
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