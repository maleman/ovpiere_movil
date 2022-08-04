import 'dart:convert';

import '../model/Order.dart';

import 'package:http/http.dart' as http;

import '../utis/ApiURL.dart';

abstract class OrderService{
  Future<List<Order>> getOrders();
  void saveOrders();
}

class OrderServiceImpl implements OrderService{
  @override
  Future<List<Order>> getOrders() async{
    // TODO: implement getOrders
    final response = await http.get(Uri.parse("${ApiURL.orderAPI}/all"));
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((o) => Order.fromJson(o)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  void saveOrders() {
    // TODO: implement saveOrders
  }

}