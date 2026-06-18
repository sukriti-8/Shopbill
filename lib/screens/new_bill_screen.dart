import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bill_item.dart';
import '../models/bill.dart';

class NewBillScreen extends StatefulWidget {
  final List<Bill> savedBills;
  final int nextBillNo;

  const NewBillScreen({
    super.key,
    required this.savedBills,
    required this.nextBillNo,
  });

  @override
  State<NewBillScreen> createState() => _NewBillScreenState();
}

class _NewBillScreenState extends State<NewBillScreen> {
  String itemName = '';
  String partyName = '';
  int qty = 0;
  double rate = 0;
  double amount = 0;
  double discount = 0;

  List<BillItem> items = [];

  final itemController = TextEditingController();
  final partyController = TextEditingController();
  final qtyController = TextEditingController();
  final rateController = TextEditingController();
  final discountController = TextEditingController();

    int currentBillNo=1;

    @override
    void initState() {
      super.initState();
      currentBillNo = widget.nextBillNo;
    }

  double getGrandTotal() {
    double total = 0;

    for (var item in items) {
      total += item.amount;
    }

    return total;
  }
  double getFinalTotal() {
    return getGrandTotal() - discount;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Bill'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Bill No: $currentBillNo',
              ),

              const SizedBox(height: 8),

              Text(
                'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              ),

              const SizedBox(height: 20),
              TextField(
                controller: partyController,
                decoration: const InputDecoration(
                    labelText: 'Party Name',
                    border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                    partyName = value;
                },
            ),

        const SizedBox(height: 15),

              TextField(
                controller: itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  itemName = value;
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    qty = int.tryParse(value) ?? 0;
                    amount = qty * rate;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rate',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    rate = double.tryParse(value) ?? 0;
                    amount = qty * rate;
                  });
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Amount: ₹$amount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    items.add(
                      BillItem(
                        itemName: itemName,
                        qty: qty,
                        rate: rate,
                        amount: amount,
                      ),
                    );

                    itemName = '';
                    qty = 0;
                    rate = 0;
                    amount = 0;

                    itemController.clear();
                    qtyController.clear();
                    rateController.clear();
                  });
                },
                child: const Text('Add Item'),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                 onPressed: () {
                  setState(() {

                    final bill = Bill(
                      billNo: currentBillNo,
                      date: DateTime.now(),
                      items: List.from(items),
                      partyName: partyName,
                      discount: discount,
                      grandTotal: getFinalTotal(),
                    );

                    widget.savedBills.add(bill);

                    final box = Hive.box('bills');
                    box.add(bill.toMap());

                    final settingsBox = Hive.box('settings');
                    settingsBox.put('nextBillNo', currentBillNo + 1);

                    currentBillNo++;
                    items.clear();

                    itemName = '';
                    partyName = '';
                    qty = 0;
                    rate = 0;
                    amount = 0;
                    discount = 0;
                    itemController.clear();
                    partyController.clear();
                    qtyController.clear();                              rateController.clear();
                    discountController.clear();
                   });
                  },
                   child: const Text('Save Bill'),
                 ),
           

              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].itemName),
                    subtitle: Text(
                      'Qty: ${items[index].qty} | Rate: ${items[index].rate}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${items[index].amount}',
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Discount',
                    border: OutlineInputBorder(),
                 ),
                 onChanged: (value) {
                    setState(() {
                        discount = double.tryParse(value) ?? 0;
                     });
                 },
                ),

                const SizedBox(height: 15),

                Text(
                    'Subtotal: ₹${getGrandTotal()}',
                     style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                     ),
                ),

                const SizedBox(height: 10),

                Text(
                    'Discount: ₹$discount',
                    style: const TextStyle(
                     fontSize: 18,
                    ),
                ),

              const SizedBox(height: 10),
              Text(
                'Grand Total: ₹${getFinalTotal()}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}