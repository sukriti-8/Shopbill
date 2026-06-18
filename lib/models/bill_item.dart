class BillItem {
  String itemName;
  int qty;
  double rate;
  double amount;

  BillItem({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'qty': qty,
      'rate': rate,
      'amount': amount,
    };
  }

  factory BillItem.fromMap(Map<dynamic, dynamic> map) {
    return BillItem(
      itemName: map['itemName'],
      qty: map['qty'],
      rate: map['rate'],
      amount: map['amount'],
    );
  }
}