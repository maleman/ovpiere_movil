import 'dart:collection';

import 'package:ovpiere_movil/model/Partner.dart';
import '../model/Product.dart';

abstract class CartOrderService {
  void setPartner(Partner partner);

  void addProductToCart(Product product, int qty);

  void removeProductFromCart(Product product);

  double getTotal();

  double getSubTotal();

  double getTaxTotal();

  Partner getPartner();

  HashMap<Product, int> getProductCart();

  int getProductCount();
}

class CartOrderServiceImpl extends CartOrderService {
  double _total = 0;
  double _subTotal = 0;
  double _taxTotal = 0;
  late Partner _partner;
  final HashMap<Product, int> _cartProducts = HashMap<Product, int>();

  @override
  void addProductToCart(Product product, int qty) {
    // TODO: implement addProductToCart
    if (qty <= 0) return;

    _cartProducts[product] = qty;
    calculate();
  }

  @override
  void removeProductFromCart(Product product) {
    // TODO: implement removeProductFromCart
    _cartProducts.remove(product);
    calculate();
  }

  @override
  double getSubTotal() {
    // TODO: implement getSubTotal
    return _subTotal;
  }

  @override
  double getTaxTotal() {
    // TODO: implement getTaxTotal
    return _taxTotal;
  }

  @override
  double getTotal() {
    // TODO: implement getTotal
    return _total;
  }

  @override
  void setPartner(Partner partner) {
    // TODO: implement setPartner
    _partner = partner;
  }

  void calculate() {
    _subTotal = 0;
    _cartProducts.forEach((key, value) {
      _subTotal = (key.price * value) + _subTotal;
    });
    print(_subTotal);
    _taxTotal = _subTotal * 0.15;
    _total = _subTotal + _taxTotal;
  }

  @override
  Partner getPartner() {
    // TODO: implement getPartner
    return _partner;
  }

  @override
  HashMap<Product, int> getProductCart() {
    // TODO: implement getProductCart
    return _cartProducts;
  }

  @override
  int getProductCount(){
    return _cartProducts.length;
  }
}
