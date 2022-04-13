

class Reclamation {
  String utilisateur_id;
  String fournisseur_id;
  String contenu;
  String type;
  String etat;

  Reclamation({
    this.utilisateur_id,
    this.fournisseur_id,
    this.contenu,
    this.type,
    this.etat,
  });
  Reclamation.Reclamation1(String utilisateur_id, String fournisseur_id , String contenu, String type)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.contenu=contenu;
    this.type=type;
  }
  Reclamation.Reclamation2(String utilisateur_id, String fournisseur_id , String contenu, String type,String etat)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.contenu=contenu;
    this.type=type;
    this.etat=etat;
  }


  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      utilisateur_id: json['utilisateur_id'],
      fournisseur_id: json['fournisseur_id'],
      contenu: json['contenu'],
      type: json['type'],
      etat: json['etat'],
    );
  }


}
