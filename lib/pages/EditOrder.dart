import 'package:flutter/material.dart';
import 'package:ovpiere_movil/model/Order.dart';
import 'package:ovpiere_movil/model/Partner.dart';

class EditOrder extends StatefulWidget{
  const EditOrder({Key? key, Partner? partner, Order? order}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditOrdersState();

}

class _EditOrdersState extends State<EditOrder>{
  final String _title = 'Agregar orden';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Agregar nuevas ordenes.',
            ),
          ],
        ),
      ),
    );
  }

}