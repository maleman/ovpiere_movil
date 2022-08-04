import 'OrderLine.dart';
import 'Partner.dart';

class Order {
  final int orderId;
  final String documentNo;
  final double totalOrder;
  final Partner partner;
  final List<OrderLine> orderLine;

  const Order(this.orderId, this.documentNo, this.partner, this.totalOrder,
      this.orderLine);

  factory Order.fromJson(Map<String, dynamic> json) {
    var partnerFromJson = json['partner'];
    Partner partner = Partner.fromJson(partnerFromJson);

    var lines = json['orderLine'] as List;
    List<OrderLine> orderLines =
        lines.map((l) => OrderLine.fromJson(l)).toList();
    return Order(json['orderId'] as int, json['documentNo'] as String, partner,
        json['totalOrder'] as double, orderLines);
  }
}
