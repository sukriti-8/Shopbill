class FastBillRow {
  String itemName;
  int qty;
  double rate;

  FastBillRow({
    this.itemName = '',
    this.qty = 0,
    this.rate = 0,
  });

  double get amount => qty * rate;
}