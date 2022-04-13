
import 'package:Deppannini/models/Adresse.dart';

class SimpleUser {
  String username;
  String image;
  String phone;
  Adresse adresse;
  String role;
  String id;

  SimpleUser({
    this.username,
    this.adresse,
    this.image,
    this.phone,
    this.role
  });
    SimpleUser.User1(String username, Adresse adresse , String image , String phone,String role)
  {
    this.username=username;
    this.adresse=adresse;
    this.image=image;
    this.phone=phone;
    this.role=role;
  }

  SimpleUser.User2( String username,Adresse adresse)
  {
    this.username=username;
    this.adresse=adresse;
  }

  SimpleUser.User3(String phone)
  {
    this.phone=phone;
  }

  SimpleUser.User4(String image, String username,String role,Adresse adresse)
  {

    this.image=image;
    this.username=username;
    this.role=role;
    this.adresse=adresse;

  }
  SimpleUser.User5(String username)
  {
    this.username=username;
  }

  SimpleUser.User6(String username, Adresse adresse , String image , String phone,String role,String id)
  {
    this.username=username;
    this.adresse=adresse;
    this.image=image;
    this.phone=phone;
    this.role=role;
    this.id=id;
  }
  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      username: json["username"] as String,
      image: json["image"] as String,
      phone: json["num_tel"] as String,
      adresse: Adresse.fromJson(json["adresse"]),
      role: json["role"] as String,

    );
  }

}
