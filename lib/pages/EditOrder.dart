import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ovpiere_movil/model/Partner.dart';

import '../model/Product.dart';

class EditOrder extends StatefulWidget {
  final Partner partner;
  final HashMap<Product, int> cartProducts;

  const EditOrder({Key? key, required this.partner, required this.cartProducts})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditOrdersState();
}

class _EditOrdersState extends State<EditOrder> {
  final String _title = 'Agregar orden';
  double _total = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    setTotal();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Cliente : ${widget.partner.name} '),
            ),
          ),
          StreamBuilder(
            builder: (BuildContext context,
                AsyncSnapshot<HashMap<Product, int>> snapshot) {
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                    child: Text("No hay productos"));
              }
              return SliverList(delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                var _product = snapshot.data!.keys.toList()[index];
                var _quantity = snapshot.data![_product];

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: .5, color: Colors.black54),
                    ),
                  ),
                  child: Dismissible(
                      key: Key(_product.code + _product.description),
                      direction: DismissDirection.endToStart,
                      background: Container(color: Colors.red[300]),
                      child: Container(
                        child: ListTile(
                          title: Text(_product.code + _product.description),
                          subtitle: Text('Qty in cart: $_quantity'),
                          trailing: Text("${_product.price * _quantity!}"),
                        ),
                      ),
                      onDismissed: (DismissDirection dir) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "$_product removed from cart.",
                            ),
                          ),
                        );
                      }),
                );
              }));
            },
          )
        ],
      ),
    );
  }

  void setTotal() {
    double total = 0;
    widget.cartProducts.forEach((key, value) {
      total = (key.price * value) + total;
    });
    setState(() {
      _total = total;
    });
  }
}
