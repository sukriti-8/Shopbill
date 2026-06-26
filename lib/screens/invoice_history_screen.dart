import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() =>
      _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState
    extends State<InvoiceHistoryScreen> {

  List invoices = [];

  @override
  void initState() {
    super.initState();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getStringList('invoice_history') ?? [];

    invoices =
        data.map((e) => jsonDecode(e)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice History"),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {

          final invoice = invoices[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                invoice['party'],
              ),
              subtitle: Text(
                invoice['date'],
              ),
              trailing: Text(
                "₹${invoice['total']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}