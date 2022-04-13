
class Adresse {
  String adresseRue;
  String adresseVille;
  String adressePays;
  String adresseGourvernement;
  String adresseComplet;

  Adresse({
    this.adresseRue,
    this.adresseVille,
    this.adressePays,
    this.adresseGourvernement,
    this.adresseComplet,
  });
  Adresse.Adresse1(String adresseComplet ,String adresseRue,String adresseVille,String adressePays,String adresseGourvernement)
  {
    this.adresseComplet="Rue: "+adresseRue+",Gouvernement: "+adresseGourvernement+", Ville: "+adresseVille+", Pays: "+adressePays;
    this.adresseRue=adresseRue;
    this.adresseVille=adresseVille;
    this.adressePays=adressePays;
    this.adresseGourvernement=adresseGourvernement;
  }

  factory Adresse.fromJson(Map<String, dynamic> json) {
    return Adresse(
      adresseRue: json["rue"],
      adresseVille:json["ville"],
      adressePays:json["pays"],
      adresseGourvernement:json["gourvernement"],
      adresseComplet:json["adresseComplet"],

    );
  }






}
