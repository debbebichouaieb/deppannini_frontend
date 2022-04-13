import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class liste_fournisseur_view extends StatefulWidget {
  const liste_fournisseur_view({Key key, this.callBack}) : super(key: key);

  final Function() callBack;
  @override
  _liste_fournisseur_viewState createState() => _liste_fournisseur_viewState();
}

class _liste_fournisseur_viewState extends State<liste_fournisseur_view> {

  var id_categorie=null;
  List<FournisseurService> fournisseurServices=[];
  List<FournisseurService> fournisseurServicesTemp=[];
  bool _isLoading = false;
  String id_user="";
  getFournisseurService(String id_categorie,String id_user)async
  {

    fournisseurServicesTemp = await fournisseurServiceController().getListeFournisseurService(id_user,id_categorie);

        setState(() {
          fournisseurServices= fournisseurServicesTemp;
        });

  }

  checkStatus() async {
    print("i entered checkstatus");
    final Map arguments = ModalRoute.of(context).settings.arguments ;
    print(arguments);
    if (arguments != null) {
      setState(() {
        id_categorie = arguments['id_categorie'];
      });
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        id_user=sharedPreferences.getString("userId");
      });

      print("USER ID "+id_user);
      this.getFournisseurService(id_categorie,id_user);
    }

  }
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.checkStatus();

    });

    if(fournisseurServices != null) {
      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = true;
      });
    }

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
      _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) : ListView.builder(
        physics: const BouncingScrollPhysics(), //ça fait le scroll du liste
        itemCount:fournisseurServices.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: ()=>  Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': fournisseurServices[index].fournisseur_id}),
                  child:
                  Image.network(
                    fournisseurServices[index].user.image,
                    height: 90,
                    width: 90,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: SizedBox(
                    child:new Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.vertical, // main axis (rows or columns)
                      children: <Widget>[
          Row(
          children: [
          Icon(
          Icons.person,
          color: Color(0xFFf1962d),
          size: 20,
          ),
                        Text(fournisseurServices[index].user.username,
                          style: TextStyle(
                          color: Color(0xFF225088),
                    fontSize: 14.0,
                  ),),
          ],
          ),
          Row(
          children: [
          Icon(
          Icons.location_on,
          color: Color(0xFFf1962d),
          size: 20,
          ),
                        Text(fournisseurServices[index].user.adresse.adresseGourvernement,
                          style: TextStyle(
                            color: Color(0xFF225088),
                            fontSize: 14.0,
                          ),),
          ],
          ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          );
        },
      ),
    );
          }
        }

