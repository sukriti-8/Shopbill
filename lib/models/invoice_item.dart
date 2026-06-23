class InvoiceItem {
  String itemName;
  String hsnCode;
  int qty;
  double rate;

  InvoiceItem({
    this.itemName = '',
    this.hsnCode = '',
    this.qty = 0,
    this.rate = 0,
  });

  double get taxableValue {
    return qty * rate;
  }
}