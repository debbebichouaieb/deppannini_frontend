
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:Deppannini/models/FournisseurService.dart';
class Favoris {
  String fournisseur_id;
  String utilisateur_id;


  Favoris({
    this.fournisseur_id,
    this.utilisateur_id,

  });
  
  Favoris.Favoris1(String fournisseur_id, String utilisateur_id)
  {
    this.fournisseur_id=fournisseur_id;
    this.utilisateur_id=utilisateur_id;

  }



}
