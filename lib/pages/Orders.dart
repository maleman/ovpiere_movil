import 'package:flutter/material.dart';
import 'package:ovpiere_movil/service/CartOrderService.dart';
import 'package:ovpiere_movil/service/OrderService.dart';

import '../model/Order.dart';
import 'PartnerCatalog.dart';

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
  OrderService orderService = OrderServiceImpl();
  late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    setState(() {
      _orders = orderService.getOrders();
    });
  }

  //List<Order> _orders = <Order>[];
  //int _orderCount = 0;

  void _goToAddOrder() {
    //setState(() => _counter++);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PartnerCatalog(
                cartOrderService: CartOrderServiceImpl(),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Order>>(
            future: _orders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                                'Order No. ${snapshot.data![index].orderId}'),
                            subtitle: Text(snapshot.data![index].partner.name),
                            trailing: Text(
                              'TOTAL: C\$ ${snapshot.data![index].totalOrder}',
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
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddOrder,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
