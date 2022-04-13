import 'package:flutter/material.dart';
import 'package:Deppannini/controllers/favorisController.dart';
import 'dart:async';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/LoginResponse.dart';


class liste_favoris_view extends StatefulWidget {
  final LoginResponse loginResponse;
  liste_favoris_view(this.loginResponse) : super();

  @override
  _liste_favoris_viewState createState() => _liste_favoris_viewState();
}

class _liste_favoris_viewState extends State<liste_favoris_view> {

  @override liste_favoris_view get widget => super.widget;

  var id_categorie=null;
  List<FournisseurService> fournisseurServices=[];
  List<FournisseurService> fournisseurServicesTemp=[];
  bool _isLoading = false;

  getFournisseurService()async
  {
    fournisseurServicesTemp = await favorisController().getListeFournisseurServiceFavoris(widget.loginResponse.userId);

    setState(() {
      fournisseurServices= fournisseurServicesTemp;
    });

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
  checkStatus() async {
    print("i entered checkstatus");
      this.getFournisseurService();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
      _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) :
      fournisseurServices.length!=0 ?
      ListView.builder(
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
      ) :
    Container(
    margin: const EdgeInsets.only(left: 50, right: 16,top: 130),
    decoration: BoxDecoration(
    //color: Color(0xFFa2dae9).withOpacity(0.5),
    shape: BoxShape.circle,
    ),
    child:Column(
    children: [
    /*Image.asset(
    'assets/images/stop.png',
    width: 300,
    height: 300,
    ),*/
    Text(
    "Vous n'avez pas de favoris",
    style: TextStyle(
    color: Color(0xFF225088),
    fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    );
  }
}

