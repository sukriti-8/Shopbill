import 'invoice_item.dart';

class Invoice {
  int invoiceNo;
  DateTime date;

  String partyName;
  String address;
  String gstNo;

  List<InvoiceItem> items;

  double cgstPercent;
  double sgstPercent;
  double igstPercent;

  Invoice({
    required this.invoiceNo,
    required this.date,
    required this.partyName,
    required this.address,
    required this.gstNo,
    required this.items,
    required this.cgstPercent,
    required this.sgstPercent,
    required this.igstPercent,
  });
}