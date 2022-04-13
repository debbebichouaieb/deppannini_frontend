import 'package:Deppannini/models/LoginResponse.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:Deppannini/models/Adresse.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import "package:sms_autofill/sms_autofill.dart";
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class userController {

  String adresseIP = variables().adresseIP;

   signUp(String phone) async {
    var jsonResponse = null;

    SimpleUser user = new SimpleUser.User3(phone);
    Map data = {
      'Num_tel': user.phone,
    };
    print(data);
    var response = await http.post(Uri.parse(
      "http://"+adresseIP+":3000/api/user/createUser/" ),
      body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("userId", jsonResponse['_id']);
    }
  }

  SimpleUser user ;
  List<SimpleUser> users=[];
  List<dynamic> listofUsers=[];

  Future<SimpleUser> getConnectedUserV1(String idUser) async {
    var jsonResponse = null;
    final response = await http.get(Uri.parse("http://"+adresseIP+":3000/api/user/getUser/"+idUser));
    jsonResponse = json.decode(response.body);

      var user= SimpleUser.fromJson(jsonResponse);
      print("USER "+user.username);
      Adresse ad=user.adresse;
      user=SimpleUser.User1(jsonResponse["username"],ad,jsonResponse["image"],jsonResponse["num_tel"],jsonResponse["role"]);

    return user;

  }


  Future<SimpleUser> getConnectedUserV2(String userId) async {

    var jsonResponse = null;

    var response = await http.get(Uri.parse("http://"+adresseIP+":3000/api/user/getUser/"+userId));
    jsonResponse = json.decode(response.body);

    var user= SimpleUser.fromJson(jsonResponse);
    print("USER "+user.username);
    Adresse ad=user.adresse;
    user=SimpleUser.User4(jsonResponse["image"],jsonResponse["username"],jsonResponse["role"],ad);


    return user;

  }



  Future<SimpleUser> getConnectedUserV3(String idUser) async{
    var jsonResponse = null;

    final response = await http.get(Uri.parse("http://"+adresseIP+":3000/api/user/getUser/"+idUser));
    jsonResponse = json.decode(response.body);
    print("jsonResponseeeeeeeeeeee "+jsonResponse.toString());
    var user= SimpleUser.fromJson(jsonResponse);
    print("USER "+user.username);
    Adresse ad=user.adresse;
    user=SimpleUser.User6(jsonResponse["username"],ad,jsonResponse["image"],jsonResponse["num_tel"],jsonResponse["role"],jsonResponse["_id"]);
    print("IMAAAAAAAAAAAGE1111111111111111111111111    "+user.image);
    return user;

  }



   Future<LoginResponse> loginUser(String phone) async {
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    SimpleUser user = new SimpleUser.User3(phone);
    Map data = {
      'Num_tel': user.phone,
    };
    print(data);
      var response=await http.post(Uri.parse(
      "http://"+adresseIP+":3000/api/user/Login/" ),
      body: data);

      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body login: $jsonResponse');
      LoginResponse loginResponse=new LoginResponse.LoginResponse1('${response.statusCode}',jsonResponse['userId'],
        jsonResponse['adresse'],jsonResponse['image'],
        jsonResponse['username'],jsonResponse['phone'],jsonResponse['role'],jsonResponse['adresseGouvernement']);
     sharedPreferences.setString("adresse",loginResponse.adresse);
     sharedPreferences.setString("userId",loginResponse.userId);
     sharedPreferences.setString("image",loginResponse.image);
     sharedPreferences.setString("username",loginResponse.username);
     sharedPreferences.setString("phone",loginResponse.phone);
     sharedPreferences.setString("role",loginResponse.role);
     sharedPreferences.setString("adresseGouvernement",loginResponse.adresseGouvernement);
      return loginResponse;
  }

  Dio dio = new Dio();

  Future<LoginResponse> upDate(String image,String username,String adresseComplet,String rue,String ville,String pays,String gouvernerat ) async {
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String idUser=sharedPreferences.getString("userId");

    String filename= image!=null ? image.split('/').last : null;
    Adresse adresseUser=new Adresse.Adresse1(adresseComplet, rue, ville, pays, gouvernerat);
    SimpleUser user = new SimpleUser.User2(username,adresseUser);
    FormData  formData = new FormData.fromMap({
      'image': filename!=null ? await MultipartFile.fromFile(image,filename: filename,contentType: new MediaType("image","png")) : null,
      'adresseRue':user.adresse.adresseRue,
      'adresseVille':user.adresse.adresseVille,
      'adressePays':user.adresse.adressePays,
      'adresseGourvernement':user.adresse.adresseGourvernement,
      'adresseComplet':user.adresse.adresseComplet,
      'Username':user.username
    });
    print(formData);


    Response response  = await dio.put("http://"+adresseIP+":3000/api/user/updateUser/"+idUser,
      options:Options
        (
        receiveTimeout: 5000
        ), data: formData);

      jsonResponse = response.data;
      print('Response status: ${response.statusCode}');
      print('Response body: $jsonResponse');
    print('Responseeeeeeeeeeeee: '+jsonResponse.toString());
    LoginResponse loginResponse=new LoginResponse.LoginResponse1('${response.statusCode}',jsonResponse['userId'],
      jsonResponse['adresse'],jsonResponse['image'],
      jsonResponse['username'],jsonResponse['phone'],jsonResponse['role'],jsonResponse['adresseGouvernement']);
    sharedPreferences.setString("adresse",loginResponse.adresse);
    sharedPreferences.setString("userId",loginResponse.userId);
    sharedPreferences.setString("image",loginResponse.image);
    sharedPreferences.setString("username",loginResponse.username);
    sharedPreferences.setString("phone",loginResponse.phone);
    sharedPreferences.setString("role",loginResponse.role);
    sharedPreferences.setString("adresseGouvernement",loginResponse.adresseGouvernement);
    return loginResponse;
  }

  upDateProfileUser(String username,String image) async {
    var jsonResponse = null;
    SimpleUser user = new SimpleUser.User5(username);
    Map data = {
      'Username':user.username
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String idUser=sharedPreferences.getString("idUser");
    var response  = await http.put(Uri.parse("http://"+adresseIP+":3000/api/user/updateProfileUser/"+idUser),
      body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

    }
  }


  sendSMS(String phone) async {
    var jsonResponse = null;
    SimpleUser user = new SimpleUser.User3(phone);
    String codeConfirmation = await SmsAutoFill().getAppSignature;
    print("COOOOOOOOOODE "+codeConfirmation);
    Map data = {
      'Num_tel': user.phone,
      'codeConfirmation' : codeConfirmation
    };
    print(data);
    var response = await http.post(Uri.parse(
      "http://"+adresseIP+":3000/api/user/SMS"),
      body: data);
    print(" RESPONSEEEEEEEEEEEEEEE "+response.toString());
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        //get code mil backend pour vérification
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setInt("codeVerif", jsonResponse['code']);
      }
    }
  }


}
