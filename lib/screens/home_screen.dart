import 'package:flutter/material.dart';
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewBillScreen(
                        savedBills: savedBills,
                        nextBillNo: nextBillNo,
                    ),
                  ),
                );
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