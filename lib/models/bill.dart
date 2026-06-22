import 'bill_item.dart';

enum BillStatus {
  active,
  cancelled,
}

class Bill {
  int billNo;
  DateTime date;
  List<BillItem> items;
  String partyName;
  double discountPercent;
  double balanceAdjustment;
  double grandTotal;
  BillStatus status;

  Bill({
    required this.billNo,
    required this.date,
    required this.items,
    required this.partyName,
    required this.discountPercent,
    required this.balanceAdjustment,
    required this.grandTotal,
    this.status = BillStatus.active,
  });

  Map<String, dynamic> toMap() {
    return {
      'billNo': billNo,
      'date': date.toIso8601String(),
      'partyName': partyName,
      'discountPercent': discountPercent,
      'balanceAdjustment': balanceAdjustment,
      'grandTotal': grandTotal,
      'status': status.name,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory Bill.fromMap(Map<dynamic, dynamic> map) {
    return Bill(
      billNo: map['billNo'],
      date: DateTime.parse(map['date']),
      partyName: map['partyName'],
      discountPercent: map['discountPercent'] ?? 0,
      balanceAdjustment:
         map['balanceAdjustment'] ?? 0,
      grandTotal: map['grandTotal'],
      status: map['status'] == 'cancelled'
          ? BillStatus.cancelled
          : BillStatus.active,
      items: (map['items'] as List)
          .map((item) => BillItem.fromMap(item))
          .toList(),

    );
  }
}