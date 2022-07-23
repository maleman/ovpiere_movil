import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/Product.dart';

class AddProductModalBottomSheet extends StatefulWidget {
 final Product product;
 final int quantity;

  const AddProductModalBottomSheet(
      {Key? key, required ,required this.product, required this.quantity})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddProductModalBottomSheetState();
  }
}

class _AddProductModalBottomSheetState extends State<AddProductModalBottomSheet>{

  int _quantity = 0;
  var textEditingControllerQty = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _quantity = widget.quantity;
    });
    textEditingControllerQty.text = _quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        minHeight: MediaQuery
            .of(context)
            .size
            .height / 2,
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
              '${widget.product.code} - ${widget.product.description}',
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
                        textEditingControllerQty.text = _quantity.toString();
                      }
                    }),
                SizedBox(
                  width: 100,
                  height: 60,
                  child:
                  TextField(
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
  }

}
