
class Contrat {
  String fournisseur_id;
  String fichePDF;
  String etat;

  Contrat({
    this.fournisseur_id,
    this.fichePDF,
    this.etat,

  });
  Contrat.Contrat1(String fournisseur_id)
  {
    this.fournisseur_id=fournisseur_id;


  }
  Contrat.Contrat2(String fournisseur_id, String fichePDF,String etat)
  {
    this.fournisseur_id=fournisseur_id;
    this.fichePDF=fichePDF;
    this.etat=etat;

  }



}
