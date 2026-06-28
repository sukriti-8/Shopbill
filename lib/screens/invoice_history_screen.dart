import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() =>
      _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState
    extends State<InvoiceHistoryScreen> {

  late Box invoiceBox;

  @override
  void initState() {
    super.initState();
    invoiceBox = Hive.box('invoices');
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

                  leading: CircleAvatar(
                    child: Text(
                      "${index + 1}",
                    ),
                  ),

                  title: Text(
                    invoice['party'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Invoice No : ${invoice['invoiceNo']}",
                      ),

                      Text(
                        invoice['date'] ?? '',
                      ),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        "₹${invoice['total']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () async {

                          await invoiceBox.deleteAt(index);

                        },
                      ),
                    ],
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