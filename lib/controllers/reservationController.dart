import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/Note.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/models/Adresse.dart';
import 'package:Deppannini/models/Categoryy.dart';
import 'package:Deppannini/models/Reservation.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:Deppannini/controllers/userController.dart';


class reservationController {

  Dio dio = new Dio();
  String adresseIP = variables().adresseIP;

  CreateReservation(String utilisateur_id, String fournisseur_id , String dateReservation, String timeslot) async {
    var jsonResponse = null;

    Reservation reservation = new Reservation.Reservation1(utilisateur_id,  fournisseur_id ,  dateReservation,  timeslot);

    Map data = {
      'Utilisateur_id': reservation.utilisateur_id,
      'Fournisseur_id': reservation.fournisseur_id,
      'Timeslot': reservation.timeslot,
      'Date': reservation.dateReservation,
    };

    final response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/reservation/bookAppointment"), body: data);
    if (response.statusCode == 201) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  List<Reservation> reservations = [];
  List<dynamic> listReservations = [];

  Future<List<Reservation>> getListeReservationByFournisseurDateReservationTimeslot(String fournisseur_id,String dateReservation) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse(
      "http://" + adresseIP + ":3000/api/reservation/getByHoraireFournisseurDate/" + fournisseur_id+"/"+dateReservation.toString()));


    listReservations = json.decode(response.body);

    for (int i = 0; i < listReservations.length; i++) {
      Map<String, dynamic> reservationList = listReservations[i];


      reservations.add(Reservation.Reservation2(
        reservationList["utilisateur_id"],
        reservationList["fournisseur_id"],
        reservationList["dateReservation"],
        reservationList["timeslot"],
        reservationList["etat"]));
    }

    return reservations;
  }

  List<Reservation> reservations1 = [];
  List<dynamic> listReservations1 = [];

  Future<List<Reservation>> getListeReservationByFournisseurId(String fournisseur_id,String user_id) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse(
      "http://" + adresseIP + ":3000/api/reservation/getReservationByFournisseurId/" + fournisseur_id));


    listReservations1 = json.decode(response.body);

    for (int i = 0; i < listReservations1.length; i++) {
      Map<String, dynamic> reservationList1 = listReservations1[i];

      SimpleUser user=await userController().getConnectedUserV1(reservationList1["utilisateur_id"]);

      reservations1.add(Reservation.Reservation4(
        reservationList1["utilisateur_id"],
        reservationList1["fournisseur_id"],
        reservationList1["dateReservation"],
        reservationList1["timeslot"],
        reservationList1["etat"],user));
    }

    return reservations1;
  }


  List<Reservation> reservations2 = [];
  List<dynamic> listReservations2 = [];

  Future<List<Reservation>> getListeReservationByUserId(String user_id) async {
    var jsonResponse = null;

    final response = await http.get(Uri.parse(
      "http://" + adresseIP + ":3000/api/reservation/getReservationByUserId/" + user_id));

   // print("RECLAMATION 11111   " +json.decode(response.body));

    listReservations2 = json.decode(response.body);

    for (int i = 0; i < listReservations2.length; i++) {
      Map<String, dynamic> reservationList2 = listReservations2[i];

      FournisseurService fournisseurService = await fournisseurServiceController().getFournisseurServiceById(reservationList2["fournisseur_id"].toString());
      print("fournisseurService user id "+fournisseurService.utilisateur_id);
      SimpleUser user=await userController().getConnectedUserV1(fournisseurService.utilisateur_id);

      print("utilisateur_iddddddddddd "+user.username);
      reservations2.add(Reservation.Reservation4(
        reservationList2["utilisateur_id"],
        reservationList2["fournisseur_id"],
        reservationList2["dateReservation"],
        reservationList2["timeslot"],
        reservationList2["etat"],user));
    }
    print("RECLAMATION 22222   " +reservations2.first.toString());
    return reservations2;
  }











}
