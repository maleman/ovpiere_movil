import '../model/Order.dart';

abstract class OrderService{
  List<Order> getOrders();
  void saveOrders();
}