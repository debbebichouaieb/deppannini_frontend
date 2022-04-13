import 'package:Deppannini/models/Contrat.dart';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';


class contratController {

  Contrat contrat;

  String adresseIP = variables().adresseIP;
  var response1;




  Future<String> uploadContrat (String fournisseur_id) async {
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Contrat C= new Contrat.Contrat1(fournisseur_id);
    print("donnéeeeeeeeeeeeee "+fournisseur_id);
    Map data = {
      'Fournisseur_id': C.fournisseur_id,
    };
    print("in favoris function");
    var response = await http.post(Uri.parse(
      "http://" + adresseIP + ":3000/api/contrat/createcontrat/"+fournisseur_id));

    if (response.statusCode == 201) {
      jsonResponse = json.encode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      sharedPreferences.setString("fichePDF", jsonResponse['fichePDF'].toString());
    }
    return '${response.statusCode}';
  }

  Future<Contrat> getContrat (String id_user)  async{
    var jsonResponse = null;

    String fournisseur_id= await fournisseurServiceController().getFournisseurServiceByUserId(id_user);
    print("FOURNISEUUUUUUUUUUUUUUUUUUUUUUURIDDDDDDDDDDDDDDDD    "+fournisseur_id);
     var response=await http.get(Uri.parse("http://" + adresseIP +
      ":3000/api/contrat/getbyfournisseurID/" +
      fournisseur_id));

       jsonResponse = json.decode(response.body);
       print('Response status: ${response.statusCode}');
       print('Response body: ${response.body}');
       Contrat contrat=new Contrat.Contrat2(jsonResponse['id_fournisseur'], jsonResponse['fichePDF'], jsonResponse['etat']);
       print("FICHEEEEEEEEEEEEEEEEEEEEE "+contrat.fichePDF);


       return contrat;


  }


}
