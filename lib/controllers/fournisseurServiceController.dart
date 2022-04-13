import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/models/Adresse.dart';
import 'package:Deppannini/models/Categoryy.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:Deppannini/controllers/userController.dart';

class fournisseurServiceController {

  FournisseurService fournisseurService;

  List<FournisseurService> fournisseurServices = [];
  List<dynamic> listofFournisseurServices = [];
  SimpleUser user;
  SimpleUser userFS;
  List<dynamic> listofusers = [];
  List<SimpleUser> users = [];
  String adresseIP = variables().adresseIP;
  var id_user = null;
  Dio dio = new Dio();
  String user_id=null;
  var response1;

  Future<List<FournisseurService>> getListeFournisseurService(String id_user,
    String id_categorie) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse("http://" + adresseIP +
      ":3000/api/fournisseur/getListefournisseurServiceByCategorieLocation/" +
      id_user + "/" + id_categorie));

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
            fournisseurServiceList["utilisateur_id"]
          ));

        }

    return fournisseurServices;
  }


  Future<FournisseurService> getFournisseurService(String id_fournisseur) async {

    var jsonResponseFS;
    final response = await http.get(Uri.parse("http://" + adresseIP +
      ":3000/api/fournisseur/getfournisseurService/" +
      id_fournisseur));

    jsonResponseFS = json.decode(response.body);

/*
      user_id = jsonResponseFS["utilisateur_id"];

      response1 = await http.get(Uri.parse("http://" + adresseIP + ":3000/api/user/getUser/" + user_id));

      var jsonResponse = json.decode(response1.body);


      var user = SimpleUser.fromJson(jsonResponse);
      Adresse ad = user.adresse;
      user=SimpleUser.User6(
        jsonResponse["username"], ad, jsonResponse["image"], jsonResponse["num_tel"],
        jsonResponse["role"],jsonResponse["_id"]);

*/
        fournisseurService=FournisseurService.FournisseurService5(
          jsonResponseFS["_id"],
          jsonResponseFS["categorie_id"],
          jsonResponseFS["note"].toDouble(),
          jsonResponseFS["utilisateur_id"]
        );
    return fournisseurService;
  }


  Future<String> getFournisseurServiceByUserId (String id_user) async {
    var jsonResponse = null;

     var response=await http.get(Uri.parse("http://" + adresseIP +
      ":3000/api/fournisseur/getfournisseurServiceByUserId/" +
      id_user));
       jsonResponse = json.decode(response.body);
    print("iddddddddddddd fournisseur "+ jsonResponse.toString());

       return jsonResponse['_id'];

  }

  Future<FournisseurService> getFournisseurServiceById(String id_fournisseur) async {
    var jsonResponse = null;
    final response = await http.get(Uri.parse("http://"+adresseIP+":3000/api/fournisseur/getfournisseurService/"+id_fournisseur));

    jsonResponse = json.decode(response.body);
    print("FOURNISSEUUUR "+jsonResponse.toString());
    var fournisseur= FournisseurService.fromJson(jsonResponse);

    fournisseur=FournisseurService.FournisseurService4(jsonResponse["fournisseur_id"],jsonResponse["utilisateur_id"],jsonResponse["cin"],jsonResponse["categorie_id"],jsonResponse["note"]);


    return fournisseur;

  }

  Future<String> CreatFournisseurService(String cin, String categorie_id) async {
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String idUser = sharedPreferences.getString("userId");
    FournisseurService FS = new FournisseurService.FournisseurService3(
      idUser, cin, categorie_id, 0);
    Map data = {
      'Utilisateur_id': FS.utilisateur_id,
      'Categorie_id': FS.categorie_id,
      'Cin': FS.cin
    };
    var response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/fournisseur/createfournisseurService",),
      body: data);
    sharedPreferences.setString("statusCodeTestCinFS", '${response.statusCode}');
    print("FOURNISSEUR IDDDDDD   "+'${response.body}');


    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("FOURNISSEUR IDDDDDD   "+jsonResponse['_id'].toString());
      sharedPreferences.setString("id_fournisseur", jsonResponse['_id']);
    }
    return '${response.statusCode}';
  }
}
