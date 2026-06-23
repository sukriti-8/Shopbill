import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill.dart';
import 'new_bill_screen.dart';
import 'history_screen.dart';
import 'fast_bill_screen.dart';
import 'printer_settings_screen.dart';
import 'shop_settings_screen.dart';
import 'invoice_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bill> savedBills = [];
  int nextBillNo = 1;

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  void loadBills() {
    final billsBox = Hive.box('bills');
    final settingsBox = Hive.box('settings');

    savedBills = billsBox.values
        .map((billMap) => Bill.fromMap(billMap))
        .toList();

    nextBillNo = settingsBox.get(
      'nextBillNo',
      defaultValue: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopBill'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SHOPBILL',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FastBillScreen(),
                      ),
                    );

                    setState(() {
                      loadBills();
                    });
                  },
                  child: const Text(
                    'FAST BILL',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InvoiceScreen(),
                      ),
                    );
                  },
                  child: const Text('INVOICE'),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loadBills();
                    });

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          savedBills: savedBills,
                        ),
                      ),
                    );
                  },
                  child: const Text('HISTORY'),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.store),
                                title:
                                    const Text('Shop Settings'),
                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ShopSettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.print),
                                title: const Text(
                                    'Printer Settings'),
                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const PrinterSettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.receipt),
                                title:
                                    const Text('New Bill'),
                                onTap: () async {
                                  Navigator.pop(context);

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewBillScreen(
                                        savedBills:
                                            savedBills,
                                        nextBillNo:
                                            nextBillNo,
                                      ),
                                    ),
                                  );

                                  setState(() {
                                    loadBills();
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('SETTINGS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}