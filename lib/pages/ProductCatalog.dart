import 'package:flutter/material.dart';
import 'package:ovpiere_movil/pages/EditOrder.dart';
import 'package:ovpiere_movil/service/ProductService.dart';
import '../model/Order.dart';
import '../model/Product.dart';
import '../service/CartOrderService.dart';
import '../widget/AddProductModalBottomSheet.dart';
import '../widget/NoNamedIcon.dart';

class ProductCatalog extends StatefulWidget {
  final CartOrderService cartOrderService;

  const ProductCatalog({Key? key, required this.cartOrderService, Order? order})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductCatalogState();
  }
}

class _ProductCatalogState extends State<ProductCatalog> {
  int _cartProductCount = 0;
  bool _isSearching = false;
  final myTextController = TextEditingController();
  final ProductService productService = ProductServiceImpl();

  late Future<List<Product>> _foundProducts;

  var textEditingControllerQty = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSearching = false;
      _foundProducts = productService.getProducts();
      _cartProductCount = widget.cartOrderService.getProductCount();
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
        child: FutureBuilder<List<Product>>(
            future: _foundProducts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: snapshot.data?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 5,
                    mainAxisExtent: 200,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                        child: GestureDetector(
                      onTap: () {
                        _addProductToCart(snapshot.data![index]);
                      },
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
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
                                    height: 300,
                                  ),
                                ),
                                ListTile(
                                  title: Text(snapshot.data![index].code),
                                  subtitle:
                                      Text(snapshot.data![index].description),
                                  trailing: Text(
                                      'C\$ ${snapshot.data![index].price}'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }

  void _gotoOrderDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditOrder(
            cartOrderService: widget.cartOrderService,
          ),
        )).then((value) {
      setState(() {
        _cartProductCount = widget.cartOrderService.getProductCount();
      });
    });
  }

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
          notificationCount: _cartProductCount,
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
      _foundProducts = productService.getProducts();
    });
  }

  void onSearch() {
    List<Product> result = [];
    if (myTextController.text.isNotEmpty) {
      setState(() {
        _foundProducts =
            productService.getProductsByQuery(myTextController.text);
      });
    }
  }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  void _addProductToCart(Product product) async {
    int quantity = 0;
    if (widget.cartOrderService.getProductCart().containsKey(product)) {
      quantity = widget.cartOrderService.getProductCart()[product] ?? 0;
    }
    int? qty = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return AddProductModalBottomSheet(
              product: product, quantity: quantity.toInt());
        });

    if (qty != null) {
      widget.cartOrderService.addProductToCart(product, qty);
      setState(() {
        _cartProductCount = widget.cartOrderService.getProductCount();
      });
    }
  }
}
