import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BinScreen extends StatefulWidget {
  const BinScreen({super.key});

  @override
  State<BinScreen> createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen>
    with SingleTickerProviderStateMixin {

  late TabController controller;
  late Box deletedBillsBox;
  late Box deletedInvoicesBox;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: 2,
      vsync: this,
    );
    deletedBillsBox = Hive.box('deletedBills');
    deletedInvoicesBox = Hive.box('deletedInvoices');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Recycle Bin"),
        actions: [

  IconButton(
    icon: const Icon(Icons.delete_sweep),

    onPressed: () async {

      final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Empty Bin"),
            content: const Text(
              "Delete every bill permanently?",
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

        if (controller.index == 0) {

          await deletedBillsBox.clear();

        } else {

          await deletedInvoicesBox.clear();

        }

      }

    },
  ),

],

        bottom: TabBar(
          controller: controller,
          tabs: const [

            Tab(
              text: "Fast Bills",
            ),

            Tab(
              text: "Invoices",
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: controller,

        children: [

          ValueListenableBuilder(
              valueListenable: deletedBillsBox.listenable(),
              builder: (context, Box box, _) {

                if (box.isEmpty) {
                  return const Center(
                    child: Text("No deleted bills"),
                  );
                }

                return ListView.builder(
                  itemCount: box.length,

                  itemBuilder: (context, index) {

                    final bill = box.getAt(index) as Map;

                    return Card(
                      margin: const EdgeInsets.all(8),

                      child: ListTile(

                        leading: CircleAvatar(
                          child: Text(
                            "${bill['billNo']}",
                          ),
                        ),

                        title: Text(
                          bill['partyName'],
                        ),

                        subtitle: Text(
                          "₹${bill['grandTotal']}",
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [

                            IconButton(
                              icon: const Icon(
                                Icons.restore,
                                color: Colors.green,
                              ),
                              onPressed: () async {

                                final billsBox = Hive.box('bills');

                                await billsBox.add(bill);

                                await deletedBillsBox.deleteAt(index);

                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              onPressed: () async {

                                final result = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Permanently"),
                                      content: const Text(
                                        "This bill will be permanently deleted and cannot be recovered.",
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

                                  await deletedBillsBox.deleteAt(index);

                                }

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

          ValueListenableBuilder(
            valueListenable: deletedInvoicesBox.listenable(),
            builder: (context, Box box, _) {

              if (box.isEmpty) {
                return const Center(
                  child: Text("No deleted invoices"),
                );
              }

              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {

                  final invoice = box.getAt(index) as Map;

                  return Card(
                    margin: const EdgeInsets.all(8),

                    child: ListTile(

                      leading: CircleAvatar(
                        child: Text(
                          "${invoice['invoiceNo']}",
                        ),
                      ),

                      title: Text(
                        invoice['party'] ?? '',
                      ),

                      subtitle: Text(
                        "₹${invoice['total']}",
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(
                              Icons.restore,
                              color: Colors.green,
                            ),
                            onPressed: () async {

                              final invoicesBox = Hive.box('invoices');

                              await invoicesBox.add(invoice);

                              await deletedInvoicesBox.deleteAt(index);

                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            onPressed: () async {

                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Permanently"),
                                    content: const Text(
                                      "This invoice cannot be recovered.",
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

                                await deletedInvoicesBox.deleteAt(index);

                              }

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
        ],
      ),
    );
  }
}