import 'Product.dart';

class OrderLine{
  final int orderLineId;
  final double quantity;
  final double discount;
  final double subTotal;
  final double taxTotal;
  final double total;
  final Product product;

  const OrderLine(this.orderLineId, this.subTotal, this.taxTotal, this.total, this.product, this.quantity, this.discount);

  factory OrderLine.fromJson(Map<String, dynamic> json){

    var productJson = json['product'];
    Product product = Product.fromJson(productJson);

    return OrderLine(json['orderLineId'] as int,
        json['subTotal'] as double,
        json['taxTotal'] as double,
        json['total'] as double,
        product,
        json['quantity'] as double,
        json['discount'] as double);
  }
}