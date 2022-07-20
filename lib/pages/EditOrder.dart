import 'package:flutter/material.dart';

class EditOrder extends StatefulWidget{
  const EditOrder({Key? key}) : super(key: key);

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