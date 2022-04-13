import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:Deppannini/models/Favoris.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:Deppannini/models/Adresse.dart';


class favorisController {

  Favoris favoris;

  String adresseIP = variables().adresseIP;
  var response1;




  Future<String> CreatFavoris(String fournisseur_id, String utilisateur_id) async {
    var jsonResponse = null;

    Favoris F = new Favoris.Favoris1(fournisseur_id, utilisateur_id);
    print("donnéeeeeeeeeeeeee "+fournisseur_id+"  "+utilisateur_id);
    Map data = {
      'Utilisateur': F.utilisateur_id,
      'FournisseurService': F.fournisseur_id
    };
    print("in favoris function");
    var response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/favoris/createFavoris",),
      body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return '${response.statusCode}';
  }

  FournisseurService fournisseurService;

  List<FournisseurService> fournisseurServices = [];
  List<dynamic> listofFournisseurServices = [];
  SimpleUser user;
  SimpleUser userFS;
  List<dynamic> listofusers = [];
  List<SimpleUser> users = [];
  var id_user = null;
  Dio dio = new Dio();
  String user_id=null;

  Future<List<FournisseurService>> getListeFournisseurServiceFavoris(String id_user) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse("http://" + adresseIP +
      ":3000/api/favoris/getListeFavorisByUser/" +
      id_user ));

    listofFournisseurServices = json.decode(response.body);


    for (int i = 0; i < listofFournisseurServices.length; i++) {

      Map<String,
        dynamic> fournisseurServiceList = listofFournisseurServices[i];

      user_id = listofFournisseurServices[i]["utilisateur_id"];

      response1 = await http.get(Uri.parse("http://" + adresseIP + ":3000/api/user/getUser/" + user_id));

      var jsonResponse = json.decode(response1.body);


      var user = SimpleUser.fromJson(jsonResponse);
      Adresse ad = user.adresse;
      user=SimpleUser.User1(
        jsonResponse["username"], ad, jsonResponse["image"], jsonResponse["num_tel"],
        jsonResponse["role"]);

      fournisseurServices.add(FournisseurService.FournisseurService2(
        fournisseurServiceList["_id"], user,
        fournisseurServiceList["categorie_id"],
        fournisseurServiceList["note"].toDouble(),
        fournisseurServiceList["utilisateur_id"]));

    }

    return fournisseurServices;
  }

}
