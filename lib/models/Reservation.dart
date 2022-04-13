
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/SimpleUser.dart';

class Reservation {
  String utilisateur_id;
  String fournisseur_id;
  String dateReservation;
  String timeslot;
  String etat;
  SimpleUser user;
  FournisseurService fournisseur;
  Reservation({
    this.utilisateur_id,
    this.fournisseur_id,
    this.dateReservation,
    this.timeslot,
    this.etat,
  });
  Reservation.Reservation1(String utilisateur_id, String fournisseur_id , String dateReservation, String timeslot)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.dateReservation=dateReservation;
    this.timeslot=timeslot;
  }

  Reservation.Reservation2(String utilisateur_id, String fournisseur_id , String dateReservation, String timeslot,String etat)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.dateReservation=dateReservation;
    this.timeslot=timeslot;
    this.etat=etat;
  }

  Reservation.Reservation3(String utilisateur_id, String fournisseur_id , String dateReservation, String timeslot,String etat,SimpleUser user,FournisseurService fournisseur)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.dateReservation=dateReservation;
    this.timeslot=timeslot;
    this.etat=etat;
    this.user=user;
    this.fournisseur=fournisseur;
  }

  Reservation.Reservation4(String utilisateur_id, String fournisseur_id , String dateReservation, String timeslot,String etat,SimpleUser user)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.dateReservation=dateReservation;
    this.timeslot=timeslot;
    this.etat=etat;
    this.user=user;
  }



  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      utilisateur_id: json['utilisateur_id'],
      fournisseur_id: json['fournisseur_id'],
      dateReservation: json['dateReservation'],
      timeslot: json['timeslot'],
      etat: json['etat'],
    );
  }


}
