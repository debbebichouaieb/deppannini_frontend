
class Horaire {
  String id_fournisseur;
  String jour;
  String debutMatin;
  String finMatin;
  String debutAprem;
  String finAprem;
  String etat;

  Horaire({
    this.id_fournisseur,
    this.jour,
    this.debutMatin,
    this.finMatin,
    this.debutAprem,
    this.finAprem,
    this.etat,

  });

  Horaire.Horaire1(String id_fournisseur, String jour , String debutMatin, String finMatin, String debutAprem , String finAprem , String etat)
  {
    this.id_fournisseur=id_fournisseur;
    this.jour=jour;
    this.debutMatin=debutMatin;
    this.finMatin=finMatin;
    this.debutAprem=debutAprem;
    this.finAprem=finAprem;
    this.etat=etat;
  }


  factory Horaire.fromJson(Map<String, dynamic> json) {
    return Horaire(
      id_fournisseur: json['id_fournisseur'],
      jour: json['jour'],
      debutMatin: json['debutMatin'],
      finMatin: json['finMatin'],
      debutAprem: json['debutAprem'],
      finAprem: json['finAprem'],
      etat: json['etat'],
    );
  }


}
