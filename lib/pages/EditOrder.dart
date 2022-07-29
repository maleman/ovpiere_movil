import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ovpiere_movil/model/OrderLine.dart';
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
  var numberFormat = NumberFormat("###.00", "en_US");
  List<OrderLine> _lines = [];
  final String _title = 'Agregar orden';
  double _total = 0, _subTotal = 0, _totalTax = 0;

  @override
  Widget build(BuildContext context) {
    setLines();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 100.0,
              floating: true,
              pinned: false,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Cliente: ${widget.partner.name}'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  tooltip: 'Enviar Orden',
                  onPressed: () {},
                ),
              ]),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _lines.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                '${_lines[index].product.code} - ${_lines[index].product.description}'),
                            subtitle:
                                Text('Qty: ${_lines[index].quantity} UND'),
                            trailing: Text(
                              'SUB TOTAL: C\$ ${numberFormat.format(_lines[index].subTotal)}',
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
                                  onPressed: () {},
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
                                    _deleteFromCart(_lines[index]);
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
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: Text("Sub total", textScaleFactor: 1.5),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text('C\$ ${numberFormat.format(_subTotal)}',
                            textScaleFactor: 1.5,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: Text("Impuesto ", textScaleFactor: 1.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text('C\$ ${numberFormat.format(_totalTax)}',
                          textScaleFactor: 1.5,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: Text("Total"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text('C\$ ${numberFormat.format(_total)}',style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ])
              ],
            ),
            /*child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.blueAccent,
                child: const Center(
                  child: Text(
                    'Footer',
                    style: TextStyle(color: Colors.white, letterSpacing: 4),
                  ),
                ),
              ),
            ),*/
          )
        ],
      ),
    );
  }

  void setLines() {
    double totalLines = 0, totalSubTotal = 0, totalTax = 0 ;
    List<OrderLine> oLines = [];
    widget.cartProducts.forEach((key, value) {
      double tax = 0, subTotal = 0, totalOrder = 0;
      subTotal = (key.price * value);
      tax = subTotal * 0.15;
      totalOrder = subTotal + tax;
      totalSubTotal = subTotal + totalSubTotal;
      totalTax = tax + totalTax;
      totalLines = totalOrder + totalLines;
      oLines
          .add(OrderLine(0, subTotal, tax, totalOrder, key, value.toDouble()));
    });
    setState(() {
      _total = totalLines;
      _totalTax = totalTax;
      _subTotal = totalSubTotal;
      _lines = oLines;
    });
  }

  void _deleteFromCart(OrderLine lin) {
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
                    setState(() {
                      _lines.remove(lin);
                    });

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
}
