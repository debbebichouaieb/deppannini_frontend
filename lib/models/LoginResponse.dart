
class LoginResponse {
  String statusCode;
  String userId;
  String adresse;
  String image;
  String username;
  String phone;
  String role;
  String adresseGouvernement;

  LoginResponse({
    this.statusCode,
    this.userId,
    this.adresse,
    this.image,
    this.username,
    this.phone,
    this.role,
    this.adresseGouvernement

  });
  LoginResponse.LoginResponse1(String statusCode,String userId,String adresse,String image,String username,String phone,String role,String adresseGouvernement)
  {
    this.statusCode=statusCode;
    this.userId=userId;
    this.adresse=adresse;
    this.image=image;
    this.username=username;
    this.phone=phone;
    this.role=role;
    this.adresseGouvernement=adresseGouvernement;
  }




}
