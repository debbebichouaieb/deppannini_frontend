import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/Note.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/models/Adresse.dart';
import 'package:Deppannini/models/Categoryy.dart';
import 'package:Deppannini/models/Reclamation.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:dio/dio.dart';


class reclamationController {

  Dio dio = new Dio();
  String adresseIP = variables().adresseIP;

  CreateReclamation(String fournisseur_id, String contenu, String type,String idUser) async {
    var jsonResponse = null;

    Reclamation reclamation = new Reclamation.Reclamation1(idUser, fournisseur_id, contenu,type);

    Map data = {
      'Utilisateur_id': reclamation.utilisateur_id,
      'Fournisseur_id': reclamation.fournisseur_id,
      'Contenu': reclamation.contenu,
      'Type': reclamation.type,
    };

    final response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/reclamation/createreclamation"), body: data);
    if (response.statusCode == 201) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  List<Reclamation> reclamations = [];
  List<dynamic> listReclamations = [];

  Future<List<Reclamation>> getListeReclamationByUserId(String idUser) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse(
      "http://" + adresseIP + ":3000/api/reclamation/getALLbyuserID/" + idUser));


    listReclamations = json.decode(response.body);

    for (int i = 0; i < listReclamations.length; i++) {
      Map<String, dynamic> reclamationList = listReclamations[i];


        reclamations.add(Reclamation.Reclamation2(
          reclamationList["utilisateur_id"],
          reclamationList["fournisseur_id"],
          reclamationList["contenu"],
          reclamationList["type"],
          reclamationList["etat"]));
      }

    return reclamations;
  }
}
