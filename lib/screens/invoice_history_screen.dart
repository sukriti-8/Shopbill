import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'invoice_details_screen.dart';
import '../screens/invoice_preview_screen.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() =>
      _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState
    extends State<InvoiceHistoryScreen> {

  late Box invoiceBox;
  late Box deletedInvoicesBox;

  @override
  void initState() {
    super.initState();
    invoiceBox = Hive.box('invoices');
    deletedInvoicesBox = Hive.box('deletedInvoices');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {

  final result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Clear Invoice History"),
        content: const Text(
          "Delete all invoices permanently?",
        ),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete All"),
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
          title: const Text("Invoice Numbering"),
          content: const Text(
            "What do you want to do with invoice numbering?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, "continue");
              },
              child: const Text("Continue Numbering"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, "restart");
              },
              child: const Text("Restart From 1"),
            ),

          ],
        );
      },
    );

    await invoiceBox.clear();

    if (choice == "restart") {

      final settingsBox = Hive.box('settings');

      await settingsBox.put(
        'nextInvoiceNo',
        1,
      );
    }
  }
},
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: invoiceBox.listenable(),
        builder: (context, Box box, _) {

          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No invoices found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {

              final invoice =
                  box.getAt(index) as Map;

              return Card(
                margin: const EdgeInsets.all(8),

                child: ListTile(
            
                 onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvoicePreviewScreen(
                          partyName: invoice['party'] ?? '',
                          address: invoice['address'] ?? '',
                          gstNo: invoice['gstNo'] ?? '',
                          items: (invoice['items'] as List)
                              .map<Map<String, TextEditingController>>((item) {
                            return {
                              'item': TextEditingController(text: item['item']),
                              'hsn': TextEditingController(text: item['hsn']),
                              'qty': TextEditingController(text: item['qty']),
                              'rate': TextEditingController(text: item['rate']),
                            };
                          }).toList(),
                          cgstPercent: invoice['cgstPercent'] ?? 0,
                          sgstPercent: invoice['sgstPercent'] ?? 0,
                          igstPercent: invoice['igstPercent'] ?? 0,
                          invoiceNumber: invoice['invoiceNo'],
                        ),
                      ),
                    );
                  },

                 leading: CircleAvatar(
                    radius: 24,
                    child: Text(
                      "#${invoice['invoiceNo']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  title: Text(
                    invoice['party'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invoice #${invoice['invoiceNo']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Text(invoice['date'] ?? ''),
                    ],
                  ),

                  trailing: SizedBox(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "₹${invoice['total']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 4),

                        InkWell(
                          onTap: () async {

                            final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Invoice"),
                                  content: const Text(
                                    "Move this invoice to Bin?",
                                  ),
                                  actions: [

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text("Cancel"),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("Delete"),
                                    ),

                                  ],
                                );
                              },
                            );

                            if (result == true) {

                              await deletedInvoicesBox.add(invoice);

                              print("Deleted Invoice Count = ${deletedInvoicesBox.length}");

                              await invoiceBox.deleteAt(index);

                            }

                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
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