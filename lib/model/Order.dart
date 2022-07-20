import 'OrderLine.dart';
import 'Partner.dart';

class Order{
  final String orderId;
  final String totalOrder;
  final Partner partner;
  final List<OrderLine> orderLine;
  const Order(this.orderId, this.partner, this.totalOrder, this.orderLine);
}