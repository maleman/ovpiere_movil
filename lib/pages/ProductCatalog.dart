import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ovpiere_movil/widgets/AddProductModalBottomSheet.dart';
import '../model/Order.dart';
import '../model/Partner.dart';
import '../model/Product.dart';

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
  int _quantity = 0;
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
        IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              _gotoOrderDetail();
            }),
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

  void _addOrderLine(BuildContext context, Product product) async {
    int quantity = 0;
    if (_cartProducts.containsKey(product)) {
      quantity = _cartProducts[product];
    }
    setState(() {
      _quantity = quantity;
    });
    textEditingControllerQty.text = _quantity.toString();
    int? qty = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height / 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Agregar producto",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${product.code} - ${product.description}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        iconSize: 40.0,
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 0) {
                            setState(() => _quantity--);
                            textEditingControllerQty.text =
                                _quantity.toString();
                          }
                        }),
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            int? q = int.tryParse(text);
                            if (q != null && q > 0) {
                              setState(() => _quantity = q);
                            }
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: textEditingControllerQty,
                      ),
                    ),

                    /* Text(
                      _quantity.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
                    IconButton(
                      iconSize: 40.0,
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => _quantity++);
                        textEditingControllerQty.text = _quantity.toString();
                      },
                    )
                  ],
                ),
              ),
              RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Text(
                  "Agregar".toUpperCase(),
                ),
                onPressed: () => Navigator.of(context).pop(_quantity),
              )
            ],
          ),
        );
      },
    );

    if (qty != null) {
      int q = (qty);
      setState(() {
        _cartProducts[product] = q;
      });
    }
  }
}
