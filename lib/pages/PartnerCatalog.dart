import 'package:flutter/material.dart';

import 'package:ovpiere_movil/pages/ProductCatalog.dart';
import 'package:ovpiere_movil/service/PartnerService.dart';
import '../model/Partner.dart';
import '../service/CartOrderService.dart';

class PartnerCatalog extends StatefulWidget {
  final CartOrderService cartOrderService;

  const PartnerCatalog({Key? key, required this.cartOrderService})
      : super(key: key);

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

  late List<Partner> allPartners;
  late Future<List<Partner>> _foundPartners;

  final PartnerService partnerService = PartnerServiceImpl();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSearching = false;
      _isPressed = false;
      _foundPartners = partnerService.getPartners();
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
      _foundPartners = partnerService.getPartners();
    });
  }

  void onSearch() {
    List<Partner> result = [];
    if (myTextController.text.isNotEmpty) {
      setState(() {
        _foundPartners = partnerService.getPartnersByQuery(myTextController.text);
      });
    }
  }

  Widget _getBody() {
    return Center(
        child: FutureBuilder<List<Partner>>(
      future: _foundPartners,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
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
                        child: Image.asset('images/png/maleman.png',
                            fit: BoxFit.cover),
                      ),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].description),
                      onTap: () {
                        widget.cartOrderService
                            .setPartner(snapshot.data![index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductCatalog(
                                cartOrderService:
                                widget.cartOrderService,
                              ),
                            ));
                      },
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
      },
    ));
  }

/*  Widget _getBody2() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: true
                ? ListView.builder(
                    itemCount: 0, //_foundPartners.length,
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
                                child: Image.asset('images/png/maleman.png',
                                    fit: BoxFit.cover),
                              ),
                              title: Text(_foundPartners[index].name),
                              subtitle: Text(_foundPartners[index].description),
                              onTap: () {
                                widget.cartOrderService
                                    .setPartner(_foundPartners[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductCatalog(
                                        cartOrderService:
                                            widget.cartOrderService,
                                      ),
                                    ));
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
  }*/

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }
}
