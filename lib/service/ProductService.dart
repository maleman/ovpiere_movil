import '../model/Product.dart';

abstract class ProductService{
  List<Product> getProducts();
}