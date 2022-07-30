import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ovpiere_movil/service/CartOrderService.dart';
import '../model/Product.dart';
import '../widget/AddProductModalBottomSheet.dart';
import '../widget/NoNamedIcon.dart';

class EditOrder extends StatefulWidget {
  final CartOrderService cartOrderService;

  const EditOrder({Key? key, required this.cartOrderService}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditOrdersState();
}

class _EditOrdersState extends State<EditOrder> {
  var numberFormat = NumberFormat("#,###.00", "en_US");
  int _cartProductCount = 0;
  double _total = 0, _subTotal = 0, _totalTax = 0;

  @override
  Widget build(BuildContext context) {
    setTotal();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 100.0,
              floating: true,
              pinned: false,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.cartOrderService.getPartner().name),
              ),
              actions: <Widget>[
                NoNamedIcon(
                  onTap: () {},
                  iconData: Icons.send,
                  text: '',
                ),
              ]),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:  _cartProductCount,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = widget.cartOrderService
                        .getProductCart()
                        .keys
                        .elementAt(index);
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 64,
                                maxHeight: 64,
                              ),
                              child: Image.asset('images/png/maleman.png',
                                  fit: BoxFit.cover),
                            ),
                            title: Text(
                                '${product.code} - ${product.description}'),
                            subtitle:
                                Text('Qty: ${widget.cartOrderService.getProductCart()[product]} UND'),
                            trailing: Text(
                              'C\$${product.price}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Ink(
                                decoration: const ShapeDecoration(
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _updateFromCart(product);
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Ink(
                                decoration: const ShapeDecoration(
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteFromCart(product);
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Table(
              children: [
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                    child: Text("Sub total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black45)),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text('C\$${numberFormat.format(_subTotal)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black45)),
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                    child: Text("Impuesto ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black45)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text('C\$${numberFormat.format(_totalTax)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black45)),
                    ),
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                    child: Text("Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black45)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text('C\$${numberFormat.format(_total)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black45)),
                    ),
                  ),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }

  void setTotal() {
    setState(() {
      _total = widget.cartOrderService.getTotal();
      _totalTax = widget.cartOrderService.getTaxTotal();
      _subTotal = widget.cartOrderService.getSubTotal();
      _cartProductCount = widget.cartOrderService.getProductCount();
    });
  }

  void _deleteFromCart(Product product) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmar'),
            content: const Text(
                'Esta seguro que desea eliminar el producto de la cesta?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    widget.cartOrderService.removeProductFromCart(product);
                    setTotal();
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Si')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void _updateFromCart(Product product) async {
    int quantity = 0;
    if (widget.cartOrderService.getProductCart().containsKey(product)) {
      quantity = widget.cartOrderService.getProductCart()[product] ?? 0;
    }
    int? qty = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return AddProductModalBottomSheet(
              product: product, quantity: quantity);
        });

    if (qty != null) {
      int q = (qty);
      widget.cartOrderService.addProductToCart(product, qty);
      setTotal();
    }
  }
}
