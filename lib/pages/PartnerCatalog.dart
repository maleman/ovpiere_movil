import 'package:flutter/material.dart';
import 'package:ovpiere_movil/pages/EditOrder.dart';
import '../model/Partner.dart';

class PartnerCatalog extends StatefulWidget {
  const PartnerCatalog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PartnerCatalogState();
  }
}

class _PartnerCatalogState extends State<PartnerCatalog> {
  bool _isSearching = false;
  bool _isPressed = false;
  final myTextController = TextEditingController();

  final List<Partner> allPartners = [
    const Partner("1", "Milton Aleman", "Managua, Monte Nebo #17"),
    const Partner("2", "Karen Flores", "Managua, Casa Real #11"),
    const Partner("3", "Jose I. Rostran",
        "Managua, El Riguero Stward park 1c abajo 1/2 al sur"),
    const Partner("4", "Hernaldo Mr. H", "Managua, Casa Real #11"),
    const Partner("5", "La Colonia", "Super Mercado La Colonia"),
    const Partner("6", "La Union", "Super Mercado La Union"),
    const Partner("6", "Maxi Pali", "Super Mercado Maxi Pali"),
  ];

  List<Partner> _foundPartners = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSearching = false;
      _isPressed = false;
      _foundPartners = allPartners;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _isSearching
          ? getAppBarSearching(onSearchCancel, onSearch, myTextController)
          : getAppBarNotSearching("Clientes", startSearching),
      body: _getBody(),
    );
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
        padding: const EdgeInsets.only(bottom: 10, right: 10),
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
      _foundPartners = allPartners;
    });
  }

  void onSearch() {
    List<Partner> result = [];
    if(myTextController.text.isNotEmpty){
      result = allPartners.where((partner) => partner.name.toLowerCase().contains(myTextController.text.toLowerCase())).toList();
    }else{
      result = allPartners;
    }

    setState(() {
      _foundPartners = result;
    });
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: _foundPartners.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundPartners.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: _isPressed ? Colors.blueAccent : Colors.white,
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
                                child: Image.asset('images/png/maleman.png', fit: BoxFit.cover),
                              ),
                              title: Text(_foundPartners[index].name),
                              subtitle: Text(_foundPartners[index].description),
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) => EditOrder(partner: _foundPartners[index]),
                                  )
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Text(
                    'No hay resultados.',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }
}
