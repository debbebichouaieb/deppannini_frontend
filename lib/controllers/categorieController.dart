
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Deppannini/models/Categoryy.dart';
import 'package:Deppannini/environnement/variables.dart';


class categorieController{

  String adresseIP= variables().adresseIP;
  List<Categoryy> categories=[];
  List<dynamic> listofCategories;

  Future<List<Categoryy>> getCategories() async {
    var response = await http.get(Uri.parse("http://"+adresseIP+":3000/api/categorie/getListeCategories"));

    listofCategories=json.decode(response.body);
    print("listofCategories "+listofCategories.length.toString());
    for (int i = 0; i < listofCategories.length; i++) {
      Map<String, dynamic> categoriesList = listofCategories[i];

         categories.add(Categoryy.Categoryy1(categoriesList["_id"],categoriesList["titre"],categoriesList["image"]));



    }
    return  categories;

  }

  Future<List<Categoryy>> getCategoriesByType(String type) async {
    var response = await http.get(Uri.parse("http://"+adresseIP+":3000/api/categorie/getListeCategoriesByType/"+type));

    listofCategories=json.decode(response.body);
    print("listofCategories "+listofCategories.length.toString());
    for (int i = 0; i < listofCategories.length; i++) {
      Map<String, dynamic> categoriesList = listofCategories[i];

      categories.add(Categoryy.Categoryy1(categoriesList["_id"],categoriesList["titre"],categoriesList["image"]));



    }
    return  categories;

  }
}
