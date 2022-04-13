class Categoryy {
  Categoryy({
    this.id,
    this.titre = '',
    this.image = '',
  });

  Categoryy.Categoryy1(this.id,this.titre,this.image);

  String id;
  String titre;
  String image;

  factory Categoryy.fromJson(Map<String, dynamic> json) {
    return Categoryy(
      titre: json["tite"] as String,
      image: json["image"] as String,
    );
  }
  static List<String> CategoryyList = <String>[
    "Esthetique","Menage","Mecanique","Electricite","Plomberie","Menage"
  ];

  /*static List<Categoryy> popularCourseList = <Categoryy>[
    Categoryy(
      imagePath: 'assets/images/3.png',
      titre: 'App Design Course',

    ),
    Categoryy(
      imagePath: 'assets/images/1.png',
      titre: 'Web Design Course',

    ),
    Categoryy(
      imagePath: 'assets/images/3.png',
      titre: 'App Design Course',

    ),
    Categoryy(
      imagePath: 'assets/images/1.png',
      titre: 'Web Design Course',

    ),
  ];*/
}
