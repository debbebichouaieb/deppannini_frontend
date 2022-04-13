import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/Note.dart';
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


class noteController {

  Dio dio = new Dio();
  String adresseIP = variables().adresseIP;

  CreateNote(String fournisseur_id, double n,String idUser ) async {
    var jsonResponse = null;

    Note note = new Note.Note1(idUser, fournisseur_id, n);

    Map data = {
      'Utilisateur_id': note.utilisateur_id,
      'Fournisseur_id': note.fournisseur_id,
      'Note': note.note.toString(),
    };

    final response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/note/createnote"), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<double> CalculerNote(String fournisseur_id) async {
    var jsonResponse = null;

    var response = await http.get(Uri.parse(
      "http://" + adresseIP + ":3000/api/note/calculerNote/" + fournisseur_id));

    if (response.statusCode == 201) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      double moyenneNote = json.decode(response.body).toDouble();

        return moyenneNote;
    }
  }
}
