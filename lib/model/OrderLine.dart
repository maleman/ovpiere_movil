import 'Product.dart';

class OrderLine{
  final String orderLineId;
  final String quantity;
  final String subTotal;
  final String taxTotal;
  final String total;
  final Product product;

  const OrderLine(this.orderLineId, this.subTotal, this.taxTotal, this.total, this.product, this.quantity);
}