import 'Product.dart';

class OrderLine{
  final int orderLineId;
  final double quantity;
  final double subTotal;
  final double taxTotal;
  final double total;
  final Product product;

  const OrderLine(this.orderLineId, this.subTotal, this.taxTotal, this.total, this.product, this.quantity);
}