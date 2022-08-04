import 'dart:convert';

import 'package:ovpiere_movil/utis/ApiURL.dart';

import '../model/Product.dart';
import 'package:http/http.dart' as http;

abstract class ProductService {
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByQuery(String query);
}

class ProductServiceImpl implements ProductService {
  @override
  Future<List<Product>> getProducts() async {
    // TODO: implement getProducts
    final response = await http.get(Uri.parse("${ApiURL.productsAPI}/all"));
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<Product>> getProductsByQuery(String query) async {
    // TODO: implement getProducts
    final response = await http.get(Uri.parse("${ApiURL.productsAPI}/$query"));
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
