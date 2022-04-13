import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/Horaire.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:dio/dio.dart';


class horaireController {

  Dio dio = new Dio();
  String adresseIP = variables().adresseIP;

  CreateHoraire(String fournisseur_id, String jour,String debMatin, String finMat, String debAprem, String finAprem,String etat ) async {
    var jsonResponse = null;

    Horaire horaire = new Horaire.Horaire1(fournisseur_id, jour , debMatin,finMat,debAprem , finAprem, etat);

    Map data = {
      'FournisseurId': horaire.id_fournisseur,
      'Jour': horaire.jour,
      'DebutMatin': horaire.debutMatin,
      'FinMatin': horaire.finMatin,
      'DebutAprem': horaire.debutAprem,
      'FinAprem': horaire.finAprem,
      'Etat': horaire.etat,
    };

    final response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/horaire/createHoraire"), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  List<Horaire> horaires = [];
  List<dynamic> listHoraires = [];

  Future<List<Horaire>> getListeHorairesByFournisseurId(String idFournisseur) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse(
      "http://" + adresseIP + ":3000/api/horaire/getHorairebyfournisseurID/" + idFournisseur));


    listHoraires = json.decode(response.body);

    for (int i = 0; i < listHoraires.length; i++) {
      Map<String, dynamic> horairesList = listHoraires[i];


      horaires.add(Horaire.Horaire1(
        horairesList["id_fournisseur"],
        horairesList["jour"],
        horairesList["debutMatin"],
        horairesList["finMatin"],
        horairesList["debutAprem"],
        horairesList["finAprem"],
        horairesList["etat"]));
    }

    print("horairessssssssssssssssss "+horaires.toString());
    return horaires;
  }


}
