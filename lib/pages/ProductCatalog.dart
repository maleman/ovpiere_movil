import 'dart:collection';
import 'package:flutter/material.dart';
import '../model/Order.dart';
import '../model/Partner.dart';
import '../model/Product.dart';
import '../widget/AddProductModalBottomSheet.dart';
import '../widget/NoNamedIcon.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({Key? key, Partner? partner, Order? order})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductCatalogState();
  }
}

class _ProductCatalogState extends State<ProductCatalog> {
  bool _isSearching = false;
  final myTextController = TextEditingController();

  final List<Product> allProduct = [
    const Product('A', 'A001', 'A fur alles', '10.50'),
    const Product('B', 'B001', 'B fur kinder', '8.90'),
    const Product('C', 'C001', 'C fur Mann', '7.90'),
    const Product('D', 'D001', 'D fur Frau', '15.90'),
    const Product('E', 'E001', 'E fur kinder', '3.90'),
    const Product('F', 'F001', 'F fur kinder', '3.90'),
    const Product('G', 'G001', 'G fur Alles', '4.78'),
  ];

  List<Product> _foundProducts = [];
  final HashMap _cartProducts = HashMap<Product, int>();

  var textEditingControllerQty = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSearching = false;
      _foundProducts = allProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _isSearching
          ? getAppBarSearching(onSearchCancel, onSearch, myTextController)
          : getAppBarNotSearching("Catalogo", startSearching),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: _foundProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5,
            mainAxisExtent: 200,
          ),
          itemBuilder: (context, index) {
            return Card(
                elevation: 10.0,
                child: GestureDetector(
                  onTap: () {
                    _addProductToCart(_foundProducts[index]);
                  },
                  child: Container(
                    height: 200,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'images/png/maleman.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              _foundProducts[index].code,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(_foundProducts[index].description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  void _gotoOrderDetail() {}

  AppBar getAppBarNotSearching(String title, Function startSearchFunction) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              startSearchFunction();
            }),
        NoNamedIcon(
          onTap: () {
            _gotoOrderDetail();
          },
          iconData: Icons.shopping_cart,
          text: '',
          notificationCount: _cartProducts.length,
        ),
      ],
    );
  }

  AppBar getAppBarSearching(Function cancelSearch, Function searching,
      TextEditingController searchController) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            cancelSearch();
          }),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5, right: 5),
        child: TextField(
          controller: searchController,
          onEditingComplete: () {
            searching();
          },
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          decoration: const InputDecoration(
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  void startSearching() {
    setState(() {
      _isSearching = true;
    });
  }

  void onSearchCancel() {
    setState(() {
      _isSearching = false;
      _foundProducts = allProduct;
    });
  }

  void onSearch() {
    List<Product> result = [];
    if (myTextController.text.isNotEmpty) {
      result = allProduct
          .where((product) => product.description
              .toLowerCase()
              .contains(myTextController.text.toLowerCase()))
          .toList();
    } else {
      _foundProducts = allProduct;
    }

    setState(() {
      _foundProducts = result;
    });
  }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  void _addProductToCart(Product product) async {
    int quantity = 0;
    if (_cartProducts.containsKey(product)) {
      quantity = _cartProducts[product];
    }
    int? qty = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return AddProductModalBottomSheet(
              product: product, quantity: quantity);
        });

    if (qty != null) {
      int q = (qty);
      setState(() {
        _cartProducts[product] = q;
      });
    }
  }
}
