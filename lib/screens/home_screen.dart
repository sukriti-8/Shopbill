import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill.dart';
import 'new_bill_screen.dart';
import 'history_screen.dart';

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

      setState(() {
        savedBills = billsBox.values
            .map((billMap) => Bill.fromMap(billMap))
            .toList();

        nextBillNo = settingsBox.get('nextBillNo', defaultValue: 1);
      });
    }
      Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopBill'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ShopBill'),

            const SizedBox(height: 20),

           ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewBillScreen(
                        savedBills: savedBills,
                        nextBillNo: nextBillNo,
                      ),
                    ),
                  );

                  setState(() {
                    loadBills();
                  });
                },
                child: const Text('New Bill'),
              ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      savedBills: savedBills,
                    ),
                  ),
                );
              },
              child: const Text('Bill History'),
            ),
          ],
        ),
      ),
    );
  }
}