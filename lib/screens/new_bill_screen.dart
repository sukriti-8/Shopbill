import 'package:flutter/material.dart';
import '../models/bill_item.dart';


class NewBillScreen extends StatefulWidget {
  const NewBillScreen({super.key});
  @override
  State<NewBillScreen> createState() => _NewBillScreenState();
}
class _NewBillScreenState extends State<NewBillScreen>{
    String itemName = '';
    int qty = 0;
    double rate = 0;
    double amount = 0;
    List<BillItem> items = [];
    final itemController = TextEditingController();
    final qtyController = TextEditingController();
    final rateController = TextEditingController();
    double getGrandTotal() {
        double total = 0;

    for (var item in items) {
        total += item.amount;
  }

  return total;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Bill'),
      ),
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        'Bill No: 1',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 8),

      const Text('Date: Today'),

      const SizedBox(height: 20),

      TextField(
        controller: itemController,
        onChanged: (value) {
            itemName = value;
        },
        decoration: const InputDecoration(
            labelText: 'Item Name',
            border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 15),

      TextField(
        controller: qtyController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
         setState(() {
            qty = int.tryParse(value) ?? 0;
            amount = qty * rate;
            });
        },
        decoration: const InputDecoration(
            labelText: 'Quantity',
            border: OutlineInputBorder(),
  ),
),

      const SizedBox(height: 15),

      TextField(
        controller: rateController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
            setState(() {
                rate = double.tryParse(value) ?? 0;
                amount = qty * rate;
            });
        },
        decoration: const InputDecoration(
            labelText: 'Rate',
            border: OutlineInputBorder(),
        ),
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

        print(items);
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
    const SizedBox(height: 20),
    Expanded(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index){
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
                            icon: const Icon(Icons.delete),
                             onPressed: () {
                             setState(() {
                                items.removeAt(index);
                             });
                        },
                    ),
                ],
            ),
                );
            },
        ),
    ),
    const SizedBox(height: 10),

    Text(
        'Grand Total: ₹${getGrandTotal()}',
    style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
     ),
    ),
    ],
  ),
),
    );
  }
}
