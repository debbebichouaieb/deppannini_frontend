
import 'package:Deppannini/models/SimpleUser.dart';

class FournisseurService {
  String fournisseur_id;
  String utilisateur_id;
  SimpleUser user;
  String categorie_id;
  String cin;
  num note;


  FournisseurService({
    this.fournisseur_id,
    this.utilisateur_id,
    this.user,
    this.categorie_id,
    this.cin,
    this.note,

  });
  FournisseurService.FournisseurService1(String fournisseur_id, String utilisateur_id , String cin )
  {
    this.fournisseur_id=fournisseur_id;
    this.categorie_id=categorie_id;
    this.utilisateur_id=utilisateur_id;
    this.cin=cin;

  }

  FournisseurService.FournisseurService2(String fournisseur_id, SimpleUser user,String categorie_id , num note, String utilisateur_id)
  {
    this.fournisseur_id=fournisseur_id;
    this.user=user;
    this.categorie_id=categorie_id;
    this.note=note;
    this.utilisateur_id=utilisateur_id;
  }

  FournisseurService.FournisseurService3(String utilisateur_id , String cin ,String categorie_id,num note)
  {

    this.categorie_id=categorie_id;
    this.utilisateur_id=utilisateur_id;
    this.cin=cin;
    this.note=note;
  }

  FournisseurService.FournisseurService4(String fournisseur_id,String utilisateur_id , String cin ,String categorie_id,num note)
  {

    this.fournisseur_id=fournisseur_id;
    this.categorie_id=categorie_id;
    this.utilisateur_id=utilisateur_id;
    this.cin=cin;
    this.note=note;
  }
  FournisseurService.FournisseurService5(String fournisseur_id,String categorie_id , num note, String utilisateur_id)
  {
    this.fournisseur_id=fournisseur_id;
    this.categorie_id=categorie_id;
    this.note=note;
    this.utilisateur_id=utilisateur_id;
  }
  factory FournisseurService.fromJson(Map<String, dynamic> json) {
    return FournisseurService(
      fournisseur_id: json["fournisseur_id"] as String,
      utilisateur_id: json["utilisateur_id"] as String,
      categorie_id: json["categorie_id"] as String,
      cin: json["cin"] as String,
      note: json["note"] ,

    );
  }

}
