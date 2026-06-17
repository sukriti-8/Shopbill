import 'bill_item.dart';

enum BillStatus {
  active,
  cancelled,
}

class Bill {
  int billNo;
  DateTime date;
  List<BillItem> items;
  double discount;
  double grandTotal;
  BillStatus status;

  Bill({
    required this.billNo,
    required this.date,
    required this.items,
    required this.discount,
    required this.grandTotal,
    this.status = BillStatus.active,
  });
}