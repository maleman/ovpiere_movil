import 'package:flutter/material.dart';
import 'package:ovpiere_movil/model/OrderLine.dart';
import 'package:ovpiere_movil/model/Partner.dart';
import 'package:ovpiere_movil/model/Product.dart';

import '../model/Order.dart';
import 'EditOrder.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrdersState();
  }
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _orders = _generateOrdersEx();
      _orderCount = _orders.length;
    });
  }

  List<Order> _orders = <Order>[];
  int _orderCount = 0;

  void _goToAddOrder() {
    //setState(() => _counter++);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditOrder()),
    );
  }

  List<Order> _generateOrdersEx() {
    final list = <Order>[];

    list.add(const Order(
        "1",
        Partner("1", "Milton Aleman", "Managua, Monte Nebo #17"),
        "21.40", <OrderLine>[
      OrderLine("1", "10.50", "0.50", "11.00",
          Product('A', 'A001', 'A fur alles', '10.50'), "1"),
      OrderLine("2", "8.90", "1.50", "10.40",
          Product('B', 'B001', 'B fur kinder', '8.90'), "1")
    ]));

    list.add(const Order(
        "2",
        Partner("2", "Karen Flores", "Managua, Casa Real #11"),
        "53.20", <OrderLine>[
      OrderLine("1", "10.50", "0.50", "22.00",
          Product('A', 'A001', 'A fur alles', '10.50'), "2"),
      OrderLine("2", "8.90", "1.50", "31.20",
          Product('B', 'B001', 'B fur kinder', '8.90'), "3")
    ]));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _orderCount == 0
          ? const Center(
              child: Text('No tienes nuevos pedidos.'),
            )
          : ListView.builder(
              itemCount: _orderCount,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('Order No. ${_orders[index].orderId}'),
                        subtitle: Text(_orders[index].partner.name),
                        trailing: Text(
                          'TOTAL: C\$ ${_orders[index].totalOrder}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                              onPressed: () {},
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddOrder,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
