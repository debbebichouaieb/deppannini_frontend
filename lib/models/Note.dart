

class Note {
  String utilisateur_id;
  String fournisseur_id;
  double note;

  Note({
    this.utilisateur_id,
    this.fournisseur_id,
    this.note
  });

  Note.Note1(String utilisateur_id, String fournisseur_id , double note)
  {
    this.utilisateur_id=utilisateur_id;
    this.fournisseur_id=fournisseur_id;
    this.note=note;
  }
  Note.Note2(double note)
  {
    this.note=note;
  }
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      utilisateur_id: json['utilisateur_id'],
      fournisseur_id: json['fournisseur_id'],
      note: json['note'],
    );
  }


}
