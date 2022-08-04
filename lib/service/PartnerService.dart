import 'dart:convert';

import 'package:ovpiere_movil/model/Partner.dart';

import '../utis/ApiURL.dart';

import 'package:http/http.dart' as http;

abstract class PartnerService {
  Future<List<Partner>> getPartners();
  Future<List<Partner>> getPartnersByQuery(String query);
}

class PartnerServiceImpl extends PartnerService {
  @override
  Future<List<Partner>> getPartners() async {
    // TODO: implement getProducts
    final response = await http.get(Uri.parse("${ApiURL.partnerAPI}/all"));
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((p) => Partner.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load partners');
    }
  }

  @override
  Future<List<Partner>> getPartnersByQuery(String query) async {
    // TODO: implement getProducts
    final response = await http.get(Uri.parse("${ApiURL.partnerAPI}/$query"));
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((p) => Partner.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load partners');
    }
  }


}
